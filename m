Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886AbaGCHeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 03:34:06 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:62817 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756AbaGCHeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 03:34:04 -0400
Message-ID: <53B50767.2010209@dev.mellanox.co.il>
Date: Thu, 03 Jul 2014 10:33:59 +0300
From: Sagi Grimberg <sagig@dev.mellanox.co.il>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
        Mikulas Patocka <mpatocka@redhat.com>
CC: Sagi Grimberg <sagig@mellanox.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: Re: Crash on WRITE SAME
References: <alpine.LRH.2.02.1407021338550.20183@file01.intranet.prod.int.rdu2.redhat.com> <20140702181333.GA15792@infradead.org> <alpine.LRH.2.02.1407021423240.20183@file01.intranet.prod.int.rdu2.redhat.com> <20140702183607.GA19117@infradead.org>
In-Reply-To: <20140702183607.GA19117@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/2/2014 9:36 PM, Christoph Hellwig wrote:
> On Wed, Jul 02, 2014 at 02:29:05PM -0400, Mikulas Patocka wrote:
>> And what about protection information for commands that transfer partial
>> sectors? (for example, UMAP transfers 24 bytes). Should
>> scsi_transfer_length return 24 or 32 in this case?
> As far as I understand so far PI is only defined for READ/WRITE
> commands.  But I'll defer to Martin who is a much better source for
> information on this topic.

hch is correct, PI supported operations are (stated in SBC)

a) COMPARE AND WRITE;
b) ORWRITE (16);
c) ORWRITE (32);
d) READ (10);
e) READ (12);
f) READ (16);
g) READ (32);
h) VERIFY (10);
i) VERIFY (12);
j) VERIFY (16);
k) VERIFY (32);
l) WRITE (10);
m) WRITE (12);
n) WRITE (16);
o) WRITE (32);
p) WRITE AND VERIFY (10);
q) WRITE AND VERIFY (12);
r) WRITE AND VERIFY (16);
s) WRITE AND VERIFY (32);
t) WRITE SAME (10);
u) WRITE SAME (16);
v) WRITE SAME (32);
y) XDWRITEREAD (10);
z) XDWRITEREAD (32);
aa) XPWRITE (10); and
ab) XPWRITE (32).

Sagi.
