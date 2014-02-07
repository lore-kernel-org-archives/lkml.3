Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaBGOgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 09:36:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43401 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbaBGOgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 09:36:36 -0500
Date: Fri, 7 Feb 2014 14:36:29 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Levente Kurusa <levex@linux.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Anssi Hannula <anssi.hannula@iki.fi>,
        Takashi Iwai <tiwai@suse.de>, Stephen Warren <swarren@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 3.11 229/233] ALSA: hda - hdmi: introduce patch_nvhdmi()
Message-ID: <20140207143629.GB5499@hercules>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
 <1391773652-25214-230-git-send-email-luis.henriques@canonical.com>
 <52F4CA77.5060007@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F4CA77.5060007@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 12:58:47PM +0100, Levente Kurusa wrote:
> Hi,
> 
> On 02/07/2014 12:47 PM, Luis Henriques wrote:
> > 3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.
> >  [...]
> >  
> > +static int patch_nvhdmi(struct hda_codec *codec)
> > +{
> > +	struct hdmi_spec *spec;
> > +	int err;
> > +
> > +	err = patch_generic_hdmi(codec);
> > +	if (err)
> > +		return err;
> > +
> > +	spec = codec->spec;
> > +
> > +	return 0;
> > +}
> > [...]
> 
> Is it just me or is it that the 'spec' variable has no use?

This does seem a little bit odd indeed.  I've picked the backport provided
by Stephen, which has been queued for the 3.10 and 3.12 stable kernels as
well.  The original patch actually modifies the ops field in the hdmi_spec
struct, however this field doesn't exist in this kernel version.

Stephen, could you please comment?  Since this is just a partial backport
of 611885bc963a ("ALSA: hda - hdmi: Disallow unsupported 2ch remapping on
NVIDIA codecs"), I'm assuming this is correct -- although the spec
variable could have been dropped.

Cheers,
--
Luis
