Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab3EMHpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 03:45:22 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19187 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab3EMHpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 03:45:21 -0400
Message-ID: <519099E4.1070709@oracle.com>
Date: Mon, 13 May 2013 15:44:36 +0800
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Reply-To: zhenzhong.duan@oracle.com
Organization: oracle
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        xen-devel@lists.xensource.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yuval Shaia <yuval.shaia@oracle.com>,
        Feng Jin <joe.jin@oracle.com>, Chien Yen <chien.yen@oracle.com>
Subject: Re: [PATCH] xen: reuse the same pirq allocated when driver load first
 time
References: <518A0A50.1020705@oracle.com> <20130510185339.GD2562@phenom.dumpdata.com>
In-Reply-To: <20130510185339.GD2562@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2013-05-11 02:53, Konrad Rzeszutek Wilk wrote:
> On Wed, May 08, 2013 at 04:18:24PM +0800, Zhenzhong Duan wrote:
>> When driver load and unload in a loop, pirq will exhaust finally.
>> Try to use the same pirq which was already mapped and binded at first time
> So what happens if I unload and reload two drivers in random order?
Same result. In fact, not only pirq exhuast issue, also driver can't be 
reloaded successfully everytime.
When trying to load driver which need to setup msix (ex. mlx4_core) it once
succeed and once failed (3rd time succeed, 4th failed etc).

zduan
