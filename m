Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841Ab3D2L1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 07:27:09 -0400
Received: from plane.gmane.org ([80.91.229.3]:39887 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757790Ab3D2L1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 07:27:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "lkml@tigusoft.pl" <lkml@tigusoft.pl>
Subject: bug? 3.2.43 hangs some tasks after network unplugged, maybe related
 to kvm
Date: Mon, 29 Apr 2013 13:26:48 +0200
Organization: tigusoft.pl
Message-ID: <kllldq$j61$1@ger.gmane.org>
Reply-To: lkml@tigusoft.pl
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: bolobolo2.torservers.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel: 3.2.43, with grsecurity security patch (with most options except
blocking kmem and ioport access) on 8 core amd cpu, 8 gb ram.

In tty1 I logged into root, then su into another user (uid=1001).

In bash, when I typed "dme" and pressed TAB to auto complete, it hanged.
Now the text cursor just blinks there, pressing anything line ctrl+C
does nothing. Going to tty2 and back works (but does not unhang the bash).

This bash process shows up as "S+" state in ps aux.
Attaching strace -p into it resulted in the strace hanging too, after
writting Process 4936 attached - interrupt to quit (ctrl+C does nothing).

A moment before the hang occured (2-3 seconds) the ethernet cable was
unplugged.
There where bridges (br, tun/tap) configured because there where kvm
machines running (one machine, kvm3) and few other where stopped.

Maybe that was related to recent 3.2.43 kvm exploits/corruptions in some
way.

The kernel has overall normal debian configuration, except it was
configured for lowest latency (low latency desktop) and afiar had more
HZ ticks (1000?).






