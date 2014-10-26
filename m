Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469AbaJZKf5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 06:35:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbaJZKfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 06:35:55 -0400
Date: Sun, 26 Oct 2014 11:33:15 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: Re: 3.18-rc0: iwlegacy failed after a while
Message-ID: <20141026103314.GB2588@redhat.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB31B552E3F@hasmsx107.ger.corp.intel.com>
 <20141024121240.GA3177@redhat.com>
 <20141025114246.GA16230@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141025114246.GA16230@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2014 at 01:42:46PM +0200, Pavel Machek wrote:
> > Since 3.17 we have only 2 minor iwlegacy changes on current linus tree.
> > If this is a regression it's probably caused by different subsystem
> > changes, most likely by PCI changes. If this is not regression, such
> > errors could be caused by enabling PS, but that has to be done
> > explicitly, Pavel did you enable power_save ? 
> 
> This is running pretty standart MATE desktop, and no, I don't think I
> enabled that.

It can be checked by "iw dev wlan0 get power_save" .

More important quiestions: Is this regression, did you see this error
before? How reproducible is this problem?

There is this message in the dmesg:

iwl3945 0000:03:00.0: BSM uCode verification failed at addr 0x00003800+0 (of 900), is 0xa5a5a5a2, s/b 0xf802020

0xa5a5a5a2 value suggest that we disconnect from the PCI bus, hence
this could be also a H/W problem.

Stanislaw
