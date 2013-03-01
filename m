Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367Ab3CAOmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 09:42:14 -0500
Received: from mx14.lb01.inode.at ([62.99.145.16]:8080 "EHLO mx.inode.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750779Ab3CAOmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 09:42:13 -0500
X-Greylist: delayed 84869 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Mar 2013 09:42:12 EST
From: Michal Bachraty <michal.bachraty@streamunlimited.com>
To: Daniel Mack <zonque@gmail.com>
Cc: perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        lgirdwood@gmail.com, "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        Vaibhav Bedia <vaibhav.bedia@ti.com>
Subject: Re: [alsa-devel] [PATCH v3] davinci-mcasp: Add support for multichannel playback
Date: Fri, 01 Mar 2013 15:42:07 +0100
Message-ID: <1751937.m7T84ofGdH@ganymedes>
Organization: Stream Unlimited GmbH
User-Agent: KMail/4.8.4 (Linux/3.2.0-29-generic-pae; KDE/4.8.4; i686; ; )
In-Reply-To: <5130AFA1.7000808@gmail.com>
References: <1362064028-12666-1-git-send-email-michal.bachraty@streamunlimited.com> <5130AFA1.7000808@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Authenticated-Sender: michal.bachraty@streamunlimited.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

Thanks for testing.

> One thing that has to be considered by users of the driver is that the
> 'serial-dir' DT property has to contain enough '1' entries for
> multichannel playback (or enough '2's for multichannel record). So this
> information is not actually something that describes the hardware, but
> rather some resource that can be and should be allocated dynamically by
> the driver at run-time. Should we consider dropping this property?

Not really, ' serial-dir' also  configures specific serializer binded with 
certain AXR pin . That means, when you have harware, which do not have aviable 
AXR0, you can enable other ARX pin.  

example:

serial-dir = <  1 0 0 0 >; /* 0: INACTIVE, 1: TX, 2: RX */ 
// activate serializer 0, active pin ARX0 in Transmit mode, first audio 
// channels are played on ARX0 pin 

serial-dir = < 0 1 1 2 >; /* 0: INACTIVE, 1: TX, 2: RX */ 
// activate serializer 1,2,3 active pin ARX1 in TX mode, ARX2, in TX mode, 
// ARX3 in RX mode

In this case, if you are using TDM mode with 2 slots, first two channels will 
be played on ARX1 and second two on ARX2. 

McAsp fills data for serializers in loop (receive and playback has separate 
loop), so if you have configuration:

serial-dir = < 1 2 0 1 >; /* 0: INACTIVE, 1: TX, 2: RX */ 
// first two channels are played on ARX0 pin, and second two on ARX3

Best,
Michal

