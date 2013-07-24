Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab3GXQJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 12:09:52 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:59316 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab3GXQJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 12:09:49 -0400
MIME-Version: 1.0
Date: Thu, 25 Jul 2013 00:09:48 +0800
Message-ID: <CAJULonjD9Rt1ObvC4S_V7pOkd78BT3LjzivBfPNpYrCDdLsJJQ@mail.gmail.com>
Subject: How are cpu physical id & processor determined in /proc/cpuinfo ?
From: Yanfei Wang <backyes@gmail.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We found that, the sequence of processor and physical id are not same
with different platform.

Conf 1:

6cores processor *2 with numa-enabled.
kernel 3.1.0
Ceontos 6.3

Conf 2:

6cores processor *2 with numa-enabled.
kernel 3.1.0
Ceontos 6.3

Conf 1 and Conf2 own same OS, kernel, and CPU, the sequences of
physical id from "cat /proc/cpuinfo" is not same.

Conf1 has sequence  with "cat /proc/cpuinfo |grep "physical id""
physical id:0
physical id:1
physical id:0
physical id:1
physical id:0
physical id:1
physical id:0
physical id:1
physical id:0
physical id:1
physical id:0
physical id:1
...
Conf2 has following sequence instead:
physical id:0
physical id:0
physical id:0
physical id:0
physical id:0
physical id:0
physical id:1
physical id:1
physical id:1
physical id:1
physical id:1
physical id:1

--------
different cpu physical id sequence can probably causes severe
numa-cross memory access for our program whose memory allocation
depends directly on the logical cpu id, rather than carefully get numa
node information with portable numa-API.

Any one can clarify our trouble, thanks a lot.

BR.
Yanfei Wang
