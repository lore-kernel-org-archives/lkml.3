Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab3KYWca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 17:32:30 -0500
Received: from hm1479-39.locaweb.com.br ([201.76.49.220]:35074 "EHLO
	hm1479-39.locaweb.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab3KYWcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 17:32:25 -0500
X-LocaWeb-COR: locaweb_2009_x-mail
Message-ID: <5293C88E.9000203@cesarb.eti.br>
Date: Mon, 25 Nov 2013 20:00:46 -0200
From: Cesar Eduardo Barros <cesarb@cesarb.eti.br>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Daniel Borkmann <dborkman@redhat.com>, James Yonan <james@openvpn.net>
CC: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Weimer <fw@deneb.enyo.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: more robust crypto_memneq
References: <1385327535-27991-1-git-send-email-cesarb@cesarb.eti.br> <529373C7.10201@openvpn.net> <52937A51.6070603@redhat.com>
In-Reply-To: <52937A51.6070603@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-locaweb-id: 5II90qkwcFl608adNSKU11Mhs1xf0MgAzPC-CIfMoteOMOLYZkorw41aZgtgCBGiz7JOWdNt-MIUbUFIqc5n_VfP5aYHWPJEum0HS-HjJOudheJEOo0glyZUwFEQ0VF7Hb1iC_FiZwJlaw2on6MVqu-sZgGntHakCCyowGVDvrnU8eDg5kZAsOGaxjl8apPjZLSCEFb2AeHznBcfQzGpZw==
x-locaweb-id2: NjM2NTczNjE3MjYyNDA2MzY1NzM2MTcyNjIyZTY1NzQ2OTJlNjI3Mg==
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.0 cv=X4Xl3hve c=1 sm=1 a=tcb3u+hY9f79lJG4QOZo8A==:17
	a=AizhB-pfR1kA:10 a=f6iRhsuteYIA:10 a=IkcTkHD0fZMA:10 a=DvNpxiHR-4UA:10
	a=GanVrVTbvUhISjmpEl4A:9 a=QEXdDO2ut3YA:10 a=5wJahwOnDtq/teZFh2NP5A==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 25-11-2013 14:26, Daniel Borkmann escreveu:
> On 11/25/2013 04:59 PM, James Yonan wrote:
>> This approach using __asm__ ("" : "=r" (var) : "0" (var)) to try to
>> prevent compiler optimizations of var is interesting.
>>
>> I like the fact that it's finer-grained than -Os and doesn't preclude
>> inlining.
>
> Agreed. This looks much better than the Makefile workaround. Do we have
> a hard guarantee that in future, this will not be detected and optimized
> away by the compiler?

That guarantee is something only the compiler people can give you. But 
given that RELOC_HIDE will break if that ever changes, and there are 
other constructs depending on the optimization-blocking behavior of 
inline assembly (like the many kinds of barriers in the kernel), I am 
not worried about that.

-- 
Cesar Eduardo Barros
cesarb@cesarb.eti.br
