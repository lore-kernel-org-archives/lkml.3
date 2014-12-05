Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933575AbaLED13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 22:27:29 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:56932 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139AbaLED11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 22:27:27 -0500
MIME-Version: 1.0
In-Reply-To: <25c04eb72c621fc9bdf0aae25782ff5bad5a4b97.1417728278.git.ashutosh.dixit@intel.com>
References: <25c04eb72c621fc9bdf0aae25782ff5bad5a4b97.1417728278.git.ashutosh.dixit@intel.com>
From: Dan Streetman <ddstreet@ieee.org>
Date: Thu, 4 Dec 2014 22:27:06 -0500
X-Google-Sender-Auth: Pho58R-SpObfiiLOzf-UhlWIUV4
Message-ID: <CALZtONBUDyN7OOMV9ziDXMhFN9+bOcsYvJ0an_7T0VV0Hz+8WQ@mail.gmail.com>
Subject: Re: [PATCH linux-next] Documentation: Build mic/mpssd only for x86_64
To: Ashutosh Dixit <ashutosh.dixit@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Jiri Kosina <jkosina@suse.cz>,
        Peter Foley <pefoley2@pefoley.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jennings <sjennings@variantweb.net>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        Nikhil Rao <nikhil.rao@intel.com>,
        Daniel Borkmann <dborkman@redhat.com>, linuxppc-dev@lists.ozlabs.org,
        Siva Yerramreddy <yshivakrishna@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2014 at 4:27 PM, Ashutosh Dixit <ashutosh.dixit@intel.com> wrote:
> mic/mpssd along with MIC drivers are currently only usable on
> x86_64. So build mic/mpssd only for x86_64 to avoid build breaks on
> big-endian systems.

Only building for x86_64 is fine, but in that case what's the point of
leaving the htole16() et. al. functions in mpssd.c?  Shouldn't they be
removed?

>
> Reported-by: Daniel Borkmann <dborkman@redhat.com>
> Reported-by: Dan Streetman <ddstreet@gmail.com>
> Suggested-by: Peter Foley <pefoley2@pefoley.com>
> Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
> ---
>  Documentation/mic/mpssd/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/mic/mpssd/Makefile b/Documentation/mic/mpssd/Makefile
> index 0f31568..f47fe6b 100644
> --- a/Documentation/mic/mpssd/Makefile
> +++ b/Documentation/mic/mpssd/Makefile
> @@ -1,5 +1,5 @@
>  # List of programs to build
> -hostprogs-y := mpssd
> +hostprogs-$(CONFIG_X86_64) := mpssd
>
>  mpssd-objs := mpssd.o sysfs.o
>
> --
> 2.0.0.rc3.2.g998f840
>
