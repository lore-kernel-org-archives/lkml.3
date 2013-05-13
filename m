Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab3EMG4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 02:56:41 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:65232 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab3EMG4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 02:56:40 -0400
MIME-Version: 1.0
In-Reply-To: <8761yn382w.fsf@rustcorp.com.au>
References: <1367842791-30285-1-git-send-email-pranavkumar@linaro.org>
	<1367842791-30285-3-git-send-email-pranavkumar@linaro.org>
	<8761yn382w.fsf@rustcorp.com.au>
Date: Mon, 13 May 2013 12:26:39 +0530
Message-ID: <CAAHg+Hi6BHqwOznnC9qxkc5pBWz7r5qpz9Nhh=EeNenhjhHohg@mail.gmail.com>
Subject: Re: [PATCH V2 2/3] Documentation: virtio: Add emergency write
 (emerg_wr) config register in virtio console.
From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        Anup Patel <anup.patel@linaro.org>, Amit Shah <amit.shah@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On 13 May 2013 08:22, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Pranavkumar Sawargaonkar <pranavkumar@linaro.org> writes:
>> Signed-off-by: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
>> Signed-off-by: Anup Patel <anup.patel@linaro.org>
>> ---
>>  Documentation/virtual/virtio-spec.txt |    8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> OK, I applied this to the lyx master, with three changes:
> 1) Changed "filed" to "field".
> 2) Added ", or even acknowledging the feature" after "without
>    initializing virtio queues".
> 3) Added an initial point to the Device Initialization section:
>
>    1. If the VIRTIO_CONSOLE_F_EMERG_WRITE feature is offered, the
>    emerg_wr field of the configuration can be written at any time. Thus
>    it should work for very early boot debugging output as well as
>    catastophic OS failures (eg. virtio ring corruption).

Thanks for applying this patch.
Have you also applied first patch ([PATCH V2 1/3] virtio: console: Add
emergency writeonly register to config space)
with this?  (https://lkml.org/lkml/2013/5/6/169)

>
> Thanks,
> Rusty.

Thanks,
Pranav

>
>> diff --git a/Documentation/virtual/virtio-spec.txt b/Documentation/virtual/virtio-spec.txt
>> index 0d6ec85..3ca38f8 100644
>> --- a/Documentation/virtual/virtio-spec.txt
>> +++ b/Documentation/virtual/virtio-spec.txt
>> @@ -1927,11 +1927,16 @@ Ports 2 onwards only if VIRTIO_CONSOLE_F_MULTIPORT is set
>>      ports; configuration fields nr_ports and max_nr_ports are
>>      valid and control virtqueues will be used.
>>
>> +  VIRTIO_CONSOLE_F_EMERG_WRITE(2) Device has support for emergency
>> +  write. Configuration filed emerg_wr is valid.
>> +
>>    Device configuration layout The size of the console is supplied
>>    in the configuration space if the VIRTIO_CONSOLE_F_SIZE feature
>>    is set. Furthermore, if the VIRTIO_CONSOLE_F_MULTIPORT feature
>>    is set, the maximum number of ports supported by the device can
>> -  be fetched.struct virtio_console_config {
>> +  be fetched. If VIRTIO_CONSOLE_F_EMERG_WRITE is set then one can
>> +  use emergency write to output single character without initializing
>> +  virtio queues. struct virtio_console_config {
>>
>>       u16 cols;
>>
>> @@ -1941,6 +1946,7 @@ Ports 2 onwards only if VIRTIO_CONSOLE_F_MULTIPORT is set
>>
>>       u32 max_nr_ports;
>>
>> +     u32 emerg_wr;
>>  };
>>
>>    Device Initialization
>> --
>> 1.7.9.5
