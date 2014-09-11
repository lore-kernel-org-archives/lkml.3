Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbaIKOiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:38:00 -0400
Received: from michael.mail.tiscali.it ([213.205.33.246]:42471 "EHLO
	michael.mail.tiscali.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaIKOh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:37:57 -0400
X-Greylist: delayed 348 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Sep 2014 10:37:57 EDT
To: linux-kernel@vger.kernel.org
Subject: AHCI maximum transfer size
X-PHP-Originating-Script: 0:rcmail.php
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 11 Sep 2014 16:32:00 +0200
From: Gionatan Danti <g.danti@assyoma.it>
Cc: g.danti@assyoma.it
Organization: Assyoma s.r.l.
Message-ID: <a39687c7cc1c7137f0187aea4ee38676@assyoma.it>
User-Agent: Roundcube Webmail/0.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
I searched the list and the internet for this question, but I did not 
find a definitive answer.

I wonder what is the maximum AHCI transfer size for kernel 2.6.32.x
Let me explain: using a command as "dd if=/dev/zero of=/dev/sda bs=2M" I 
can see, via iostat, that request-size is at 2M (as expected). However 
it seems to me that the effective transfer size is way lower: disabling 
writeback cache on the target disk, I see very low performance even for 
big-chunk transfers.

Googling, I found this post on stackoverflow stating that maximum 
observerd AHCI transfer size (with a SATA protocol analyzer) is 128KB: 
http://stackoverflow.com/questions/24053662/how-to-enlarge-sata-transfer-size-in-linux-ahci-driver.
The stackoverflow post seems to agree with this old LWN.net article: 
http://lwn.net/Articles/77981/

Anyone has any idea of how to find (and eventually change) the used AHCI 
transfer size without touching the code?

NOTE: please CC me directly.
Regards.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
