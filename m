Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369Ab3EWDjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 23:39:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756217Ab3EWDjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 23:39:20 -0400
Date: Wed, 22 May 2013 23:39:11 -0400
From: Dave Jones <davej@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
        fenghua.yu@intel.com, Takashi Iwai <tiwai@suse.de>
Subject: Re: microcode loading got really slow.
Message-ID: <20130523033911.GA9411@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
	fenghua.yu@intel.com, Takashi Iwai <tiwai@suse.de>
References: <20130521230332.GC12713@redhat.com>
 <519D1668.6000601@zytor.com>
 <20130522200012.GA15456@redhat.com>
 <ebdf0a48-4f93-48da-a0a2-b601268c8fb2@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebdf0a48-4f93-48da-a0a2-b601268c8fb2@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > On 05/21/2013 04:03 PM, Dave Jones wrote:
 > 
 > [   72.318133] microcode: CPU1 sig=0x306c3, pf=0x2, revision=0x6
 > [  132.446449] microcode: CPU2 sig=0x306c3, pf=0x2, revision=0x6
 > [  192.573101] microcode: CPU3 sig=0x306c3, pf=0x2, revision=0x6
 > [  252.702055] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
 > 
 > For some reason the events for udev seem to be getting delayed 60s
 > for each core.

Screwed up my .config, and had CONFIG_FW_LOADER_USER_HELPER inadvertantly set
Odd though that it causes that 60 second delay, given that it's supposedly a
'fallback' when the direct loading fails.

It seems I don't actually need to set that option, so I'm not bothered
if there's an actual bug here or not, but the behaviour seems odd.

	Dave

