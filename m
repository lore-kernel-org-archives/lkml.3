Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbaLOXWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 18:22:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:63345 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbaLOXWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 18:22:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="499188944"
Date: Mon, 15 Dec 2014 15:22:56 -0800
From: Kevin Strasser <kevin.strasser@linux.intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: "Strasser, Kevin" <kevin.strasser@intel.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "Lin, Mengdong" <mengdong.lin@intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Fang, Yang A" <yang.a.fang@intel.com>
Subject: Re: [alsa-devel] [PATCH] ASoC: Intel: fix possible acpi enumeration
 panic
Message-ID: <20141215232256.GC27822@H87M>
References: <1418282517-851-1-git-send-email-kevin.strasser@intel.com>
 <20141211132026.GY11764@sirena.org.uk>
 <51B6C3CD1F10FB47A5702881E0E230A74A0ECAE1@ORSMSX104.amr.corp.intel.com>
 <20141215170645.GH11764@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141215170645.GH11764@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 05:06:45PM +0000, Mark Brown wrote:
> Please fix your mailer to word wrap comfortably under 80 colums so that your
> mails are easily legible.

Understood

> > > This changes the check from verifying if a codec_id is present to
> > > verifying if the first character in the codec_id is non-NULL.  That
> > > doesn't seem obviously safer and the tables of machines seem to be
> > > terminated by having an entry with all fields set to zero (which is a
> > > common idiom in Linux) which would now crash with this change.
> 
> > In this case mach->codec_id is non-NULL, even for the terminating element,
> > because it is defined to be a fixed width. So we have to take a look at the
> > first character to see if it has been initialized.
> 
> That's a really unusual and (as you've seen) error prone idiom - is it not
> better to fix the struct to use the more common idiom?

That seems like a good idea to me. I'll prepare a new patch to change the
sst_machines definition so that codec_id gets initialized to NULL.

-Kevin
