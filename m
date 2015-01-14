Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbbANSTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 13:19:38 -0500
Received: from mga03.intel.com ([134.134.136.65]:24696 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbbANSTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 13:19:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,757,1413270000"; 
   d="scan'208";a="669920057"
Date: Wed, 14 Jan 2015 10:15:26 -0800
From: "David E. Box" <david.e.box@linux.intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Jarkko Nikula <jarkko.nikula@linux.intel.com>, jdelvare@suse.de,
        arnd@arndb.de, maxime.ripard@free-electrons.com, dianders@chromium.org,
        u.kleine-koenig@pengutronix.de,
        laurent.pinchart+renesas@ideasonboard.com,
        boris.brezillon@free-electrons.com, andrew@lunn.ch, sjg@chromium.org,
        markus.mayer@linaro.org, jacob.jun.pan@linux.intel.com,
        max.schwarz@online.de, mika.westerberg@linux.intel.com,
        skuribay@pobox.com, Romain.Baeriswyl@abilis.com, wenkai.du@intel.com,
        chiau.ee.chew@intel.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH V3 1/2] i2c-designware: Add i2c bus locking support
Message-ID: <20150114181526.GA2892@pathfinder>
References: <1411497626-7984-1-git-send-email-david.e.box@linux.intel.com>
 <1417478973-25522-1-git-send-email-david.e.box@linux.intel.com>
 <1417478973-25522-2-git-send-email-david.e.box@linux.intel.com>
 <5480144F.2040506@linux.intel.com>
 <20141204184210.GA1530@pathfinder>
 <20150113094833.GB1059@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150113094833.GB1059@katana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Expect something tonight should the latest tests run okay. I needed to include
an EPROBE_DEFER to address the unavailibity of the pci driver needed in order to
request the lock during probe of the i2c device. This due to the lock now being
requested during probe because of the hang.

Dave

On Tue, Jan 13, 2015 at 10:48:33AM +0100, Wolfram Sang wrote:
> Hi Dave,
> 
> > Timely reply. Around i2c_dw_init(), yes. I just discovered this as the source
> > of a recent hang that's occuring in the loop in __i2c_dw_enable().
> > The hange occurs very infrequently and only, so far, when not built in. A
> > block around i2c_dw_disable_int() would make sense as well as a precaution.
> 
> Any news on this or on a V4 of this series?
> 
> Thanks,
> 
>    Wolfram
> 


