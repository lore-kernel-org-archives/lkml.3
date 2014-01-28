Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbaA1Kj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 05:39:28 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:44530 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbaA1Kj1 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Tue, 28 Jan 2014 05:39:27 -0500
Message-Id: <52E796EB0200007800117804@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Tue, 28 Jan 2014 10:39:23 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Mukesh Rathor" <mukesh.rathor@oracle.com>
Cc: <roger.pau@citrix.com>, "xen-devel" <xen-devel@lists.xenproject.org>,
        <konrad.wilk@oracle.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [V0 PATCH] pvh: Disable PSE feature for now
References: <1390875519-8667-1-git-send-email-mukesh.rathor@oracle.com>
 <1390875519-8667-2-git-send-email-mukesh.rathor@oracle.com>
In-Reply-To: <1390875519-8667-2-git-send-email-mukesh.rathor@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 28.01.14 at 03:18, Mukesh Rathor <mukesh.rathor@oracle.com> wrote:
> Until now, xen did not expose PSE to pvh guest, but a patch was submitted
> to xen list to enable bunch of features for a pvh guest. PSE has not been
> looked into for PVH, so until we can do that and test it to make sure it
> works, disable the feature to avoid flood of bugs.
> 
> Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> ---
>  arch/x86/xen/enlighten.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index a4d7b64..4e952046 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1497,6 +1497,11 @@ static void __init xen_pvh_early_guest_init(void)
>  	xen_have_vector_callback = 1;
>  	xen_pvh_set_cr_flags(0);
>  
> +        /* pvh guests are not quite ready for large pages yet */
> +        setup_clear_cpu_cap(X86_FEATURE_PSE);
> +        setup_clear_cpu_cap(X86_FEATURE_PSE36);

And why would you not want to also turn of 1Gb pages then?

Jan

