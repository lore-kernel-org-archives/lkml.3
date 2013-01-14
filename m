Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab3ANKvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 05:51:39 -0500
Received: from nm16.bullet.mail.ird.yahoo.com ([77.238.189.69]:36219 "EHLO
	nm16.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756084Ab3ANKvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 05:51:38 -0500
X-Yahoo-Newman-Id: 493305.85727.bm@smtp122.mail.ird.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: zQmuDR4VM1nD8kS0bdmy2kX3vFquYIqbZGkX0JbHTVC..Yf
 YREL_hqUQ8UCWbkktHoqcrI4BIo0dq5mW1NBnh72OIjHXBtbPakwqJrTvSq_
 MwJXCnixeQ9rzKRksAmRJpBXlyJh9CUTdQLpkf6q2YN4wwd_CrJa0dhnqYco
 qeHNQcabfBK4bxxlEWbhlrYvIeM0MuARR94.ALFAW0h15tAaluZqN0by1tE4
 zKwIN879FRQW.EsVRAbXEPV2G28YH6lkLbRU7iXFSs2lj8mej8Fgbl.t0ufe
 MKtb236Hv2uP4ugBGHUDoqM_stfdoe7k6.bKLWwmVGktOkIvzrc2qM_cLR6P
 5gK4cG_p.DJRWwj2cH3EhvprMydgycrhpdwZ6xz0002PcwaxB4mkRB7v0XsX
 wpqEW5ScccvYTbBgTqWw-
X-Yahoo-SMTP: mOFZFAuswBAG4_8a4ZBj.Wmvw2Qxc4R7nmE-
From: Schrober <franzschrober@yahoo.de>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <levinsasha928@gmail.com>
Subject: Hashtable implementation breaks on flow statements
Date: Mon, 14 Jan 2013 11:51:35 +0100
Message-ID: <1482200.orrNyi3164@bentobox>
User-Agent: KMail/4.8.4 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I think the new hash implementation in include/linux/hashtable.h is slightly 
unintuitive when using things like hash_for_each, hash_for_each_rcu, 
hash_for_each_safe and hash_for_each_possible.

Users may want to get out of the loop through the hashtable iteration when 
some condition is met. This works well on hlist, list and other "abstract" 
data types. But the hash table would just jump to the next bucket and 
continue.
-- 
Franz Schrober
