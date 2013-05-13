Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab3EMC6L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 22:58:11 -0400
Received: from ozlabs.org ([203.10.76.45]:48004 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084Ab3EMC50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 22:57:26 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Rob Landley <rob@landley.net>,
        Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, anup.patel@linaro.org, amit.shah@redhat.com,
        Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Subject: Re: [PATCH V2 2/3] Documentation: virtio: Add emergency write (emerg_wr) config register in virtio console.
In-Reply-To: <1367902933.18069.212@driftwood>
References: <1367842791-30285-1-git-send-email-pranavkumar@linaro.org> <1367842791-30285-3-git-send-email-pranavkumar@linaro.org> <1367902933.18069.212@driftwood>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 13 May 2013 10:46:07 +0930
Message-ID: <87obcf3ciw.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley <rob@landley.net> writes:
> On 05/06/2013 07:19:50 AM, Pranavkumar Sawargaonkar wrote:
>> Signed-off-by: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
>> Signed-off-by: Anup Patel <anup.patel@linaro.org>
>> ---
>>  Documentation/virtual/virtio-spec.txt |    8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>> 
>> diff --git a/Documentation/virtual/virtio-spec.txt  
>> b/Documentation/virtual/virtio-spec.txt
>> index 0d6ec85..3ca38f8 100644
>> --- a/Documentation/virtual/virtio-spec.txt
>> +++ b/Documentation/virtual/virtio-spec.txt
>> @@ -1927,11 +1927,16 @@ Ports 2 onwards only if  
>> VIRTIO_CONSOLE_F_MULTIPORT is set
>>      ports; configuration fields nr_ports and max_nr_ports are
>>      valid and control virtqueues will be used.
>> 
>> +  VIRTIO_CONSOLE_F_EMERG_WRITE(2) Device has support for emergency
>> +  write. Configuration filed emerg_wr is valid.
>
> Emergency?
>
> Really?
>
> Out of morbid curiosity, what would constitute an _emergency_ in a  
> virtual machine logging context?

Usually, your console device is broken.  Or you can't set it up because
you can't allocate memory.  Or you oops before it is configured.

Terminology is a tricky thing, but the nuance here is that you don't
want to use this as your main console.  It may not do anything.  It may
drop characters.  It's definitely slow.

Cheers,
Rusty.
