Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab3F1QGg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:06:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544Ab3F1QGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:06:35 -0400
Message-ID: <51CDB480.9070705@redhat.com>
Date: Fri, 28 Jun 2013 18:06:24 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/2] lib: vsprintf: add IPv4/v6 generic %p[Ii]S[pfs]
 format specifier
References: <1372421131-1672-1-git-send-email-dborkman@redhat.com>  <1372421131-1672-2-git-send-email-dborkman@redhat.com> <1372434289.29380.6.camel@joe-AO722> <51CDB183.1070209@redhat.com>
In-Reply-To: <51CDB183.1070209@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2013 05:53 PM, Daniel Borkmann wrote:
> On 06/28/2013 05:44 PM, Joe Perches wrote:
>> On Fri, 2013-06-28 at 14:05 +0200, Daniel Borkmann wrote:
>>> In order to avoid making code that deals with printing both, IPv4 and
>>> IPv6 addresses, unnecessary complicated as for example ...
>>
>> Thanks Daniel, seems sensible.  Just trivial comments...
>
> Ok, thanks.
>
>> []
>>
>>> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
>> []
>>
>> Should any other include other than net/addrconf be needed?

Ah, you mean net/addrconf.h, ok got it. Hm, well, I've compiled and tested it, no
warning or error on my side.

> I'm not sure I understand this question.
>
>>> +char *ip6_addr_string_sa(char *buf, char *end, const struct sockaddr_in6 *sa,
>>> +             struct printf_spec spec, const char *fmt)
>>> +{
>> []
>>> +    char fmt6[2] = { fmt[0], '6'};
>>
>> This looks odd to me.  why not use a bool compressed
>> flag and identify this before the isalpha loop and not
>> have fmt6 at all?
>
> Well, we have a bool called 'have_c' that identifies if 'c' was specified. To have
> the same behaviour as with %pI6, this is used to create a temporary fmt that we then
> can pass to ip6_string(). If you look at ip6_addr_string(), it's done the same way,
> and by that, we stay compatible in behaviour.
>
>>> +    u8 off = 0;
>>> +
>>> +    fmt++;
>>> +    while (isalpha(*++fmt)) {
>>> +        switch (*fmt) {
>>> +        case 'p':
>>> +            have_p = true;
>>> +            break;
>>> +        case 'f':
>>> +            have_f = true;
>>> +            break;
>>> +        case 's':
>>> +            have_s = true;
>>> +            break;
>>> +        case 'c':
>>> +            have_c = true;
>>> +            break;
>>> +        }
>>> +    }
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
