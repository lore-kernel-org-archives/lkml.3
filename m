Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaF3NsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:48:19 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:14976 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbaF3NsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:48:17 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-4e-53b16a9ebefd
Message-id: <53B16A64.4020903@samsung.com>
Date: Mon, 30 Jun 2014 16:47:16 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>
Cc: keyrings <keyrings@linux-nfs.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: Re: [PATCH v6 4/6] KEYS: validate certificate trust only with selected
 owner key
References: <1403620852-16476-5-git-send-email-zohar@linux.vnet.ibm.com>
 <1403620852-16476-1-git-send-email-zohar@linux.vnet.ibm.com>
 <7771.1403877346@warthog.procyon.org.uk>
 <1403891079.9446.12.camel@dhcp-9-2-203-236.watson.ibm.com>
In-reply-to: <1403891079.9446.12.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t/xa7rzsjYGG+yfJ2jxruk3i8WXpXUW
	B949YbGYveshi8XlXXPYLD70PGKzuPpwNovFpxWTmB04PHbOusvuMe3EMhaPB4c2s3i833eV
	zWPdja/sHp83yQWwRXHZpKTmZJalFunbJXBlPN5+nK3gEmfFr66FbA2Mj9i7GDk4JARMJI7+
	ju9i5AQyxSQu3FvP1sXIxSEksJRRYsLl/YwQTiOTxNldX6GcWYwSi040s4K08ApoSbxavJgd
	xGYRUJXoanjDDGKzCehJbGj+ARYXFYiQOND3DKpeUOLH5HssILaIgJ/EwzMvwOqZBfqYJO5s
	EgW5SFggWuJ8nwnErveMEneud4L1cgq4Syxd+oIJol5dYtK8RVC98hKb17wFs4WAbuheu5YN
	4h1FidOTzzFPYBSehWT1LCTts5C0L2BkXsUomlqaXFCclJ5rqFecmFtcmpeul5yfu4kREkFf
	djAuPmZ1iFGAg1GJh7dxxYZgIdbEsuLK3EOMEhzMSiK8N302BgvxpiRWVqUW5ccXleakFh9i
	ZOLglGpgZNVYHKRxzPjanJCIldVMi0P01BuuBcj17Pp0eJrKtklGh0vYd03l7FuUevl4v6mL
	2efrG7QXz7onuslxp8C1uJtP1R3fM9sUfGZ8aNMTX3yDh7PvIN9K3jf9Zx2XvNz7mWP+VKU/
	q9fPWRXv1m86Zd/1F4tKs7aKZzZfF7+nFMD6dOMy1/vPvyuxFGckGmoxFxUnAgC8PBstfgIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/06/14 20:44, Mimi Zohar wrote:
> On Fri, 2014-06-27 at 14:55 +0100, David Howells wrote: 
>> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>>
>>> This patch defines a new kernel parameter 'keys_ownerid' to identify
>>> the owner's key which must be used for trust validation of certificates.
>> "ca_keys" or "only_ca" instead, maybe?
> Neither of these names reflect the concept of the machine owner or a
> local key.  The initial patches named it 'owner_keyid'.  If kernel
> parameters don't need to be prefixed with the subsystem, we could revert
> the name change or call it localca_keyid.
>
> Mimi

I neither against any of proposals.

But considering that we use those keys to verify other keys, they become
ca keys.
So from that point of view I think 'ca_keys' reflects functionality
quite ok.

localca_ prefix is may be not very relevant as builtin keys may
comesfrom kernel vendor (RH, Ubuntu)
and is not really local...

so let's decide on 'ca_keys'?

Thanks,
Dmitry

> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

