Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaIFVog (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 17:44:36 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:37314 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbaIFVof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 17:44:35 -0400
Message-ID: <540B8040.5010206@gmail.com>
Date: Sat, 06 Sep 2014 23:44:32 +0200
From: Piotr Karbowski <piotr.karbowski@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: /proc/<pid>/exe symlink behavior change in >=3.15.
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Starting with kernel 3.15 the 'exe' symlink under /proc/<pid>/ acts 
diffrent than it used to in all the pre-3.15 kernels.

The usecase:

run /root/testbin (app that just sleeps)
cp /root/testbin /root/testbin.new
mv /root/testbin.new /root/testbin
ls -al /proc/`pidof testbin`/exe

<=3.14: /root/testbin (deleted)
 >=3.15: /root/testbin.new (deleted)

Was the change intentional? It does render my system unusable and I 
failed to find a information about such change in the ChangeLog.

-- Piotr.
