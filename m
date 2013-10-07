Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab3JGQWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 12:22:51 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:65478 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab3JGQWu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 12:22:50 -0400
MIME-Version: 1.0
Date: Mon, 7 Oct 2013 18:22:48 +0200
Message-ID: <CAP145pinoutWaVCAf1xk8X-Bc8Uu=d2DD8k3w_o=V7caNLqNLA@mail.gmail.com>
Subject: Deadlock (un-killable processes) in sys_futex
From: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After fuzzing the linux kernel (3.12-rc4) I have two processes which
are stuck in an un-killable state. This is not specific to 3.12-rc4,
as I'm able to reproduce it on most modern kernels (e.g. Ubuntu's 3.5)
after a few minutes of fuzzing with a syscall fuzzer.

The debug data can be found here: http://alt.swiecki.net/linux/20327/
- process PIDs: 20327 and 13735

It includes..

ftrace report (probably the most useful):
I'm not expert in this kernel area (futex/mm), but it seems like a
constatnt loop between fault_in_user_writeable() and do_page_fault():
http://alt.swiecki.net/linux/20327/20327.trace.report.txt

/proc/pid/maps, /proc/pid/status:
http://alt.swiecki.net/linux/20327/20327.maps.txt
http://alt.swiecki.net/linux/20327/20327.status.txt

kdb stacktraces showing that both processes (single-threaded) are
stuck in sys_futex:
http://alt.swiecki.net/linux/20327/20327.kdb.txt
http://alt.swiecki.net/linux/20327/13735.kdb.txt

kgdb stacktraces displaying rather corrupted data:
http://alt.swiecki.net/linux/20327/20327.kgdb.txt
http://alt.swiecki.net/linux/20327/13735.kgdb.txt

kernel conf:
http://alt.swiecki.net/linux/20327/config-3.12-rc4.txt

-- 
Robert Święcki
