Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347AbaIEIDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 04:03:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43402 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700AbaIEIDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 04:03:36 -0400
Message-ID: <54096E56.3050809@suse.com>
Date: Fri, 05 Sep 2014 10:03:34 +0200
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, jbeulich@suse.com
Subject: Re: [PATCH 3/3] xen: eliminate scalability issues from initial mapping
 setup
References: <1409834326-29287-1-git-send-email-jgross@suse.com> <1409834326-29287-4-git-send-email-jgross@suse.com> <54086244.7020601@citrix.com>
In-Reply-To: <54086244.7020601@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2014 02:59 PM, David Vrabel wrote:
> On 04/09/14 13:38, Juergen Gross wrote:
>> Direct Xen to place the initial P->M table outside of the initial
>> mapping, as otherwise the 1G (implementation) / 2G (theoretical)
>> restriction on the size of the initial mapping limits the amount
>> of memory a domain can be handed initially.
>
> The three level p2m limits memory to 512 GiB on x86-64 but this patch
> doesn't seem to address this limit and thus seems a bit useless to me.

Yeah, there seem to be some bits missing...

I'll add another patch to support a 4 level p2m scheme in the kernel.
For the Xen tools I'll do it, too.


Juergen
