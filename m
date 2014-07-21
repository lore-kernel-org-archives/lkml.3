Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbaGUJKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 05:10:00 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51427 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753266AbaGUJJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 05:09:57 -0400
Date: Mon, 21 Jul 2014 11:09:53 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Tejun Heo <tj@kernel.org>,
        Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, kishon@ti.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 0/8] ARM: berlin: add AHCI support
Message-ID: <20140721090953.GE32208@kwain>
References: <1405686607-8126-1-git-send-email-antoine.tenart@free-electrons.com>
 <20140718135758.GB13012@htj.dyndns.org>
 <53CA4608.3040208@redhat.com>
 <53CA48F7.5020405@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53CA48F7.5020405@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Sat, Jul 19, 2014 at 12:31:19PM +0200, Hans de Goede wrote:
> On 07/19/2014 12:18 PM, Hans de Goede wrote:
> 
> >The problem is that:
> >
> >1) We need to enable resources before we can do ahci_save_initial_config()
> >2) We must do ahci_save_initial_config() before we can do ata_host_alloc_pinfo()
> >3) Therefor we don't have port_info at enable_resources time, which is when we
> >want to enable the phys (and we cannot just enable the phys elsewhere as
> >enable_resouces gets used on e.g. resume too).
> >
> >So I think it is best to just make the phy pointers an array inside
> >ahci_host_priv, with a comment that the array indexes must match port
> >indexes.
> 
> So looking at "[PATCH v10 4/8] ata: libahci: allow to use multiple PHYs"
> I see that currently the phy array indexes do not necessarily match the
> port indexes. Since you already allocate the phys array at nports size,
> I suggest simply making the array sparse, leaving in NULL entries for
> unused ports, and adjusting enable / disable_phys to check for NULL
> pointers. This way we still have a 1:1 way to map ports <-> phys if
> we want to do something with phys on a per port basis in the future.
> 
> Note please also add a check that reg < nports so that we don't use
> the array out of bounds if there is an error in the dts.

Ok. I'll rework patch 4 along with the other modifications requested,
and I'll send a new version early this week.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
