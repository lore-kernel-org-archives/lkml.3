Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbaLNWkE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 17:40:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55041 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbaLNWjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 17:39:54 -0500
Date: Sun, 14 Dec 2014 14:39:53 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Greg Donald <gdonald@gmail.com>,
        "John L. Hammond" <john.hammond@intel.com>,
        Andriy Skulysh <Andriy_Skulysh@xyratex.com>,
        Fabian Frederick <fabf@skynet.be>, James Simmons <uja.ornl@gmail.com>,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: lustre: lustre: obdclass: lprocfs_status.c: Fix
 for possible null pointer dereference
Message-ID: <20141214223953.GA4168@kroah.com>
References: <1418596582-24557-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418596582-24557-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 11:36:22PM +0100, Rickard Strandqvist wrote:
> There is otherwise a risk of a possible null pointer dereference.
> 
> Was largely found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  .../lustre/lustre/obdclass/lprocfs_status.c        |   20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
> index 61e04af..4a7891a 100644
> --- a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
> +++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
> @@ -1897,17 +1897,15 @@ int lprocfs_write_frac_u64_helper(const char *buffer, unsigned long count,
>  	}
>  
>  	units = 1;
> -	switch (*end) {
> -	case 'p': case 'P':
> -		units <<= 10;
> -	case 't': case 'T':
> -		units <<= 10;
> -	case 'g': case 'G':
> -		units <<= 10;
> -	case 'm': case 'M':
> -		units <<= 10;
> -	case 'k': case 'K':
> -		units <<= 10;
> +	if (end) {
> +		switch (*end) {
> +		case 'p': case 'P':
> +		case 't': case 'T':
> +		case 'g': case 'G':
> +		case 'm': case 'M':
> +		case 'k': case 'K':
> +			units <<= 10;
> +		}

You know you just changed the logic in the code, right?

Why?  Have you tested this?

greg k-h
