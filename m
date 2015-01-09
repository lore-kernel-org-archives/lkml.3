Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbbAIJ6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 04:58:51 -0500
Received: from exprod7og112.obsmtp.com ([64.18.2.177]:59095 "HELO
	exprod7og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754786AbbAIJ6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 04:58:49 -0500
X-Greylist: delayed 338 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Jan 2015 04:58:49 EST
Message-ID: <54AFA502.8090701@miraclelinux.com>
Date: Fri, 09 Jan 2015 18:53:06 +0900
From: YOSHIFUJI Hideaki <hideaki.yoshifuji@miraclelinux.com>
Organization: MIRACLE LINUX CORPORATION
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rahul Sharma <rsharma@arista.com>, netdev@vger.kernel.org
CC: hideaki.yoshifuji@miraclelinux.com, linux-kernel@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net v2] ipv6: Prevent ipv6_find_hdr() from returning ENOENT
 for valid non-first fragments
References: <CAFB3abzM2ApxMH6C7vSDJ8JikKEkE46bOH3jbsis2NiF-ieUxA@mail.gmail.com>
In-Reply-To: <CAFB3abzM2ApxMH6C7vSDJ8JikKEkE46bOH3jbsis2NiF-ieUxA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Rahul Sharma wrote:
> ipv6_find_hdr() currently assumes that the next-header field in the
> fragment header of the non-first fragment is the "protocol number of
> the last header" (here last header excludes any extension header
> protocol numbers ) which is incorrect as per RFC2460. The next-header
> value is the first header of the fragmentable part of the original
> packet (which can be extension header as well).
> This can create reassembly problems. For example: Fragmented
> authenticated OSPFv3 packets (where AH header is inserted before the
> protocol header). For the second fragment, the next header value in
> the fragment header will be NEXTHDR_AUTH which is correct but
> ipv6_find_hdr will return ENOENT since AH is an extension header
> resulting in second fragment getting dropped. This check for the
> presence of non-extension header needs to be removed.
>
> Signed-off-by: Rahul Sharma <rsharma@arista.com>

Acked-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>

-- 
Hideaki Yoshifuji <hideaki.yoshifuji@miraclelinux.com>
Technical Division, MIRACLE LINUX CORPORATION
