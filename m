Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbaIDNC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 09:02:58 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:30207 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489AbaIDNC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 09:02:57 -0400
X-IronPort-AV: E=Sophos;i="5.04,465,1406592000"; 
   d="scan'208";a="169069444"
Message-ID: <540862FE.7070108@citrix.com>
Date: Thu, 4 Sep 2014 14:02:54 +0100
From: Andrew Cooper <andrew.cooper3@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, Juergen Gross <jgross@suse.com>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xensource.com>,
        <konrad.wilk@oracle.com>, <boris.ostrovsky@oracle.com>,
        <jbeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH 3/3] xen: eliminate scalability issues from
 initial mapping setup
References: <1409834326-29287-1-git-send-email-jgross@suse.com>	<1409834326-29287-4-git-send-email-jgross@suse.com> <54086244.7020601@citrix.com>
In-Reply-To: <54086244.7020601@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/14 13:59, David Vrabel wrote:
> On 04/09/14 13:38, Juergen Gross wrote:
>> Direct Xen to place the initial P->M table outside of the initial
>> mapping, as otherwise the 1G (implementation) / 2G (theoretical)
>> restriction on the size of the initial mapping limits the amount
>> of memory a domain can be handed initially.
> The three level p2m limits memory to 512 GiB on x86-64 but this patch
> doesn't seem to address this limit and thus seems a bit useless to me.
>
> David

Any increase of the p2m beyond 3 levels will need to come with
substantial libxc changes first.  3 level p2ms are hard coded throughout
all the PV build and migrate code.

~Andrew
