Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576AbaBGQkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 11:40:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44037 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaBGQkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 11:40:45 -0500
Date: Fri, 7 Feb 2014 16:40:36 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Levente Kurusa <levex@linux.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, kernel-team@lists.ubuntu.com,
        Anssi Hannula <anssi.hannula@iki.fi>, Takashi Iwai <tiwai@suse.de>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 3.11 229/233] ALSA: hda - hdmi: introduce patch_nvhdmi()
Message-ID: <20140207164036.GC5499@hercules>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
 <1391773652-25214-230-git-send-email-luis.henriques@canonical.com>
 <52F4CA77.5060007@linux.com>
 <20140207143629.GB5499@hercules>
 <52F507E9.9050502@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F507E9.9050502@wwwdotorg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 09:20:57AM -0700, Stephen Warren wrote:
> On 02/07/2014 07:36 AM, Luis Henriques wrote:
> > On Fri, Feb 07, 2014 at 12:58:47PM +0100, Levente Kurusa wrote:
> >> Hi,
> >>
> >> On 02/07/2014 12:47 PM, Luis Henriques wrote:
> >>> 3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.
> >>>  [...]
> >>>  
> >>> +static int patch_nvhdmi(struct hda_codec *codec)
> >>> +{
> >>> +	struct hdmi_spec *spec;
> >>> +	int err;
> >>> +
> >>> +	err = patch_generic_hdmi(codec);
> >>> +	if (err)
> >>> +		return err;
> >>> +
> >>> +	spec = codec->spec;
> >>> +
> >>> +	return 0;
> >>> +}
> >>> [...]
> >>
> >> Is it just me or is it that the 'spec' variable has no use?
> > 
> > This does seem a little bit odd indeed.  I've picked the backport provided
> > by Stephen, which has been queued for the 3.10 and 3.12 stable kernels as
> > well.  The original patch actually modifies the ops field in the hdmi_spec
> > struct, however this field doesn't exist in this kernel version.
> > 
> > Stephen, could you please comment?  Since this is just a partial backport
> > of 611885bc963a ("ALSA: hda - hdmi: Disallow unsupported 2ch remapping on
> > NVIDIA codecs"), I'm assuming this is correct -- although the spec
> > variable could have been dropped.
> 
> The very next patch of mine to this file (in other stable releases)
> makes use of the spec variable. I kept the addition of the spec variable
> in this patch, even though it isn't used until the next patch, so that
> it stayed as part of the backport of this patch which originally added
> it, rather than moving it to the other patch I backported, and hence
> mixing up multiple upstream patches in the same backported patch.

Doh!  I've applied both of your two patches to the 3.11 kernel.  And while
I first reviewed them, I've seen that detail and it made perfect sense ;)

Anyway, thank you for your clarification.

Cheers,
--
Luis
