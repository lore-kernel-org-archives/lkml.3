Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab3L2SUE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 13:20:04 -0500
Received: from nm38.bullet.mail.ne1.yahoo.com ([98.138.229.31]:21164 "HELO
	nm38.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751667Ab3L2SUB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 13:20:01 -0500
X-Yahoo-Newman-Property: ymail-4
X-Yahoo-Newman-Id: 811820.26220.bm@omp1004.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=rv7JuCL0s2F3SfEbXAv17004DjatkBCjh+o/vUmLXGIwN3LGwbxstBQEGYdvJeXC7iIHPMHQcVvlif3mrpdsevTCeeqsIAeVVkMdybZlhJ/DIZaP9nm/FYqTi4bnPYR/pxa4ckuCcZN0NpTrzL7XK705nnq4utq+418ocz1RDek=;
X-YMail-OSG: yBYGfW0VM1nFbo4oLK.B.fKgkBbMTBBQ3pK9No0BZOsP04_
 wVw4pq.x5vfE8iddy.VgCbhjQhxRy.dTIBBpzM7ZEiolt1c2KWtpIM3xaLtF
 KLvcOVISNHbexl9ukgaWAN5O0TxmXEOgCTvPp3kF5CXdt28UpMUir_kCaPAj
 _WWkH2AYbLuuBBCXoh3aZ6tdhZgEvq5gAteigv.DmeqnlAJhQqYVE7mTK6c0
 JnP8kim6Bd6w0IzlPUury8X7Zmp5l8EKKxdRPr563qdXpiXaLeHB2cxMPXoi
 ekvEhiGgDEdexwy_rBOhcT8EDher_oAxTE.T5yFfk2id8Mz10S_rgWzofMzZ
 amqYgqFQAPg2r3OfQllPW_5ZgpXlthfe.saBZBpr.jk7iEa00I4tnl7lyjJW
 VB3X1nyiDREeDJZsL3ruBZeH0vgmhUMrMtcb8QiT7z9Z_InLli4vMs_vLFST
 8cqFZf0wleKvPCaBABGkh1UclKK9enJU6tZmq_jflro2fvIYmdpgWG4snt7U
 QR92_cotU9y4A4L0GRO7KcobTesUc4EQJzJ.3VMCvJZ2lIr2ocM.oHrG1XSG
 Fek5SPwocTCTOMRmV42KOB3qLIK8RKoom
X-Rocket-MIMEInfo: 002.001,SGksCgpJIG5lZWQgaGVscCBpbiByb3VnaGx5IGNhbGN1bGF0aW5nIHRoZSB0b3RhbCBtZW1vcnkgY29uc3VtcHRpb24gaW4gYW4gZW1iZWRkZWQgTGludXggc3lzdGVtIGp1c3QgYWZ0ZXIgYm9vdGluZyBpcyBmaW5pc2hlZC4KSSBrbm93LCBJIGNhbiBzZWUgdGhlIG1lbW9yeSBzdGF0cyB1c2luZyAiZnJlZSIgYW5kICIvcHJvYy9tZW1pbmZvIgoKQnV0LCBJIG5lZWQgdGhlIGJyZWFrdXAgb2YgIlVzZWQiIG1lbW9yeSBkdXJpbmcgYm9vdHVwLCBmb3IgYm90aCBrZXJuZWwgc3BhY2UgYW5kIHVzZXIgYXBwbGkBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.172.614
Message-ID: <1388341026.52582.YahooMailNeo@web160105.mail.bf1.yahoo.com>
Date: Sun, 29 Dec 2013 10:17:06 -0800 (PST)
From: PINTU KUMAR <pintu_agarwal@yahoo.com>
Reply-To: PINTU KUMAR <pintu_agarwal@yahoo.com>
Subject: Help about calculating total memory consumption during booting
To: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mgorman@suse.de" <mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I need help in roughly calculating the total memory consumption in an embedded Linux system just after booting is finished.
I know, I can see the memory stats using "free" and "/proc/meminfo"

But, I need the breakup of "Used" memory during bootup, for both kernel space and user application.

Example, on my ARM machine with 128MB RAM, the free memory reported is roughly:
Total: 90MB
Used: 88MB
Free: 2MB
Buffer+Cached: (5+19)MB

Now, my question is, how to find the breakup of this "Used" memory of "88MB".
This should include both kernel space allocation and user application allocation(including daemons).

If anybody knows about any tools(or techniques) please help.

Few doubts:
1) If I add up all "Pss" field in "proc/<PID>/smaps, do I get the total Used memory?
2) Is the Pss value includes the kernel side allocation as well?
3) What fields I should choose from ?proc/meminfo" to correctly arrive at the "Used" memory in the system?
4) What about the memory allocation for kernel threads during booting? Why does its Pss/Rss value shows 0 always?

Please help.


Thank You!
Regards,
Pintu
