Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902AbbAIL3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 06:29:00 -0500
Received: from mail.us.es ([193.147.175.20]:34068 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932787AbbAIL25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 06:28:57 -0500
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus1 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.5/19899. spamassassin: 3.4.0.  
 Clear:RC:1(127.0.0.1):SA:0(-104.2/7.5):. 
 Processed in 2.715403 secs); 09 Jan 2015 11:28:54 -0000
X-Spam-ASN: 
X-Envelope-From: pneira@us.es
Date: Fri, 9 Jan 2015 12:31:45 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Rahul Sharma <rsharma@arista.com>, netdev@vger.kernel.org
Cc: YOSHIFUJI Hideaki <hideaki.yoshifuji@miraclelinux.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net v2] ipv6: Prevent ipv6_find_hdr() from returning
 ENOENT for valid non-first fragments
Message-ID: <20150109113145.GA4426@salvia>
References: <CAFB3abzM2ApxMH6C7vSDJ8JikKEkE46bOH3jbsis2NiF-ieUxA@mail.gmail.com>
 <54AFA502.8090701@miraclelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AFA502.8090701@miraclelinux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 06:53:06PM +0900, YOSHIFUJI Hideaki wrote:
> Hi,
> 
> Rahul Sharma wrote:
> >ipv6_find_hdr() currently assumes that the next-header field in the
> >fragment header of the non-first fragment is the "protocol number of
> >the last header" (here last header excludes any extension header
> >protocol numbers ) which is incorrect as per RFC2460. The next-header
> >value is the first header of the fragmentable part of the original
> >packet (which can be extension header as well).
> >This can create reassembly problems. For example: Fragmented
> >authenticated OSPFv3 packets (where AH header is inserted before the
> >protocol header). For the second fragment, the next header value in
> >the fragment header will be NEXTHDR_AUTH which is correct but
> >ipv6_find_hdr will return ENOENT since AH is an extension header
> >resulting in second fragment getting dropped. This check for the
> >presence of non-extension header needs to be removed.
> >
> >Signed-off-by: Rahul Sharma <rsharma@arista.com>
> 
> Acked-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>

I already mentioned this patch will break ip6tables.

And it doesn't make sense to me that you still hit the problem with
nf_defrag_ipv6.

Could you please hold on with this patch until we clarify what the
real undelying problem is? Could you send me a pcap trace?
