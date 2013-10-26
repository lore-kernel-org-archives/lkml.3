Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab3JZHGI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 03:06:08 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:56875 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab3JZHGG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 03:06:06 -0400
MIME-Version: 1.0
In-Reply-To: <20131025084134.6cfa153a@samsung-9>
References: <1382687360-27794-1-git-send-email-zwu.kernel@gmail.com>
	<20131025084134.6cfa153a@samsung-9>
Date: Sat, 26 Oct 2013 15:06:04 +0800
Message-ID: <CAEH94Lia4VVU6Vnn_7DhOHo4yhR-tsMPu7biMCeSMgQPvkQrug@mail.gmail.com>
Subject: Re: [PATCH 1/3] vxlan: silence one build warning
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: netdev@vger.kernel.org, linux-kernel mlist <linux-kernel@vger.kernel.org>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 11:41 PM, Stephen Hemminger
<stephen@networkplumber.org> wrote:
> On Fri, 25 Oct 2013 15:49:18 +0800
> Zhi Yong Wu <zwu.kernel@gmail.com> wrote:
>
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>> drivers/net/vxlan.c: In function ‘vxlan_sock_add’:
>> drivers/net/vxlan.c:2298:11: warning: ‘sock’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>> drivers/net/vxlan.c:2275:17: note: ‘sock’ was declared here
>>   LD      drivers/net/built-in.o
>>
>> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>> ---
>>  drivers/net/vxlan.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
>> index 2ef5b62..e15f1af 100644
>> --- a/drivers/net/vxlan.c
>> +++ b/drivers/net/vxlan.c
>> @@ -2272,7 +2272,7 @@ static struct vxlan_sock *vxlan_socket_create(struct net *net, __be16 port,
>>  {
>>       struct vxlan_net *vn = net_generic(net, vxlan_net_id);
>>       struct vxlan_sock *vs;
>> -     struct socket *sock;
>> +     struct socket *sock = NULL;
>>       struct sock *sk;
>>       int rc = 0;
>>       unsigned int h;
>
> This only happens with certain versions of Gcc which have buggy dependency
> analysis. It doesn't happen with Gcc 4.7, think it only shows up in 4.4.
> I would rather not fix the warning this way since it risks masking later bugs if this code ever changes.
Gcc version is 4.7.2 on my box, this warning took palce.
# gcc -v
Using built-in specs.
COLLECT_GCC=gcc
...
gcc version 4.7.2 20120921 (Red Hat 4.7.2-2) (GCC)


-- 
Regards,

Zhi Yong Wu
