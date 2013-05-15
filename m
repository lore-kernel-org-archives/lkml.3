Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab3EOFVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 01:21:05 -0400
Received: from ozlabs.org ([203.10.76.45]:44428 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618Ab3EOFVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 01:21:00 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Cc: "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kvmarm\@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel\@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        Anup Patel <anup.patel@linaro.org>, Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH V2 2/3] Documentation: virtio: Add emergency write (emerg_wr) config register in virtio console.
In-Reply-To: <CAAHg+Hi6BHqwOznnC9qxkc5pBWz7r5qpz9Nhh=EeNenhjhHohg@mail.gmail.com>
References: <1367842791-30285-1-git-send-email-pranavkumar@linaro.org> <1367842791-30285-3-git-send-email-pranavkumar@linaro.org> <8761yn382w.fsf@rustcorp.com.au> <CAAHg+Hi6BHqwOznnC9qxkc5pBWz7r5qpz9Nhh=EeNenhjhHohg@mail.gmail.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 15 May 2013 13:59:29 +0930
Message-ID: <87hai427di.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pranavkumar Sawargaonkar <pranavkumar@linaro.org> writes:
> Hi Rusty,
>
> On 13 May 2013 08:22, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> Pranavkumar Sawargaonkar <pranavkumar@linaro.org> writes:
>>> Signed-off-by: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
>>> Signed-off-by: Anup Patel <anup.patel@linaro.org>
>>> ---
>>>  Documentation/virtual/virtio-spec.txt |    8 +++++++-
>>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> OK, I applied this to the lyx master, with three changes:
>> 1) Changed "filed" to "field".
>> 2) Added ", or even acknowledging the feature" after "without
>>    initializing virtio queues".
>> 3) Added an initial point to the Device Initialization section:
>>
>>    1. If the VIRTIO_CONSOLE_F_EMERG_WRITE feature is offered, the
>>    emerg_wr field of the configuration can be written at any time. Thus
>>    it should work for very early boot debugging output as well as
>>    catastophic OS failures (eg. virtio ring corruption).
>
> Thanks for applying this patch.
> Have you also applied first patch ([PATCH V2 1/3] virtio: console: Add
> emergency writeonly register to config space)
> with this?  (https://lkml.org/lkml/2013/5/6/169)

Would like Amit's Ack, since he's de-facto console maintainer.

I've reproduced it below.

Cheers,
Rusty.

Subject: [PATCH V2 1/3] virtio: console: Add emergency writeonly register to config space
Date: Mon,  6 May 2013 17:49:49 +0530
Message-Id: <1367842791-30285-2-git-send-email-pranavkumar@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1367842791-30285-1-git-send-email-pranavkumar@linaro.org>
References: <1367842791-30285-1-git-send-email-pranavkumar@linaro.org>
X-Gm-Message-State: ALoCoQmDOoCdPmDpT+VgLwYAlJHmkUTB8sEAHVSbrNxWBzYgPHFT9rQ2A9dR8fToM81cHDZDppGx

This patch adds an emerg_wr register (writeonly) in config space
of virtio console device which can be used for debugging.

Signed-off-by: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Signed-off-by: Anup Patel <anup.patel@linaro.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/uapi/linux/virtio_console.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/virtio_console.h b/include/uapi/linux/virtio_console.h
index ee13ab6..3fd0dce 100644
--- a/include/uapi/linux/virtio_console.h
+++ b/include/uapi/linux/virtio_console.h
@@ -38,6 +38,7 @@
 /* Feature bits */
 #define VIRTIO_CONSOLE_F_SIZE	0	/* Does host provide console size? */
 #define VIRTIO_CONSOLE_F_MULTIPORT 1	/* Does host provide multiple ports? */
+#define VIRTIO_CONSOLE_F_EMERG_WRITE 2 /* Does host support emergency write? */
 
 #define VIRTIO_CONSOLE_BAD_ID		(~(u32)0)
 
@@ -48,6 +49,8 @@ struct virtio_console_config {
 	__u16 rows;
 	/* max. number of ports this device can hold */
 	__u32 max_nr_ports;
+	/* emergency write register */
+	__u32 emerg_wr;
 } __attribute__((packed));
 
 /*


