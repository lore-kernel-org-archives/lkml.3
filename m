Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935721Ab3DHNWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 09:22:16 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:60498 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935600Ab3DHNWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 09:22:15 -0400
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Apr 2013 09:22:15 EDT
X-Sasl-enc: hiJ0GwR6YeW0bmItFTFH+d5y901kPx8OM5E0ZSr12Zxt 1365426972
Message-ID: <5162C31A.6040209@ladisch.de>
Date: Mon, 08 Apr 2013 15:16:10 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        linux-fsdevel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] [RFC] revoke(2) and generic handling of things like
 remove_proc_entry()
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> BTW, snd_card_disconnect() doesn't do anything to existing mappings; smells
> like a bug, and there we do have ones with non-trivial ->mmap().  Could
> ALSA folks comment?

I don't know of any hotplug sound driver that maps memory from a device.
All hotplug buses (PCIe, USB, FireWire) involve DMAing from/to main
memory.

When a sound device is unplugged, sample transfers just stop, but the
buffer itself stays as long as the device node is kept opened.  (In the
case of a capture device, that actually makes sense.)


Regards,
Clemens
