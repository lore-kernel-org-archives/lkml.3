Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab3CKC60 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 22:58:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:7906 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753533Ab3CKC6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 22:58:25 -0400
X-IronPort-AV: E=Sophos;i="4.84,820,1355068800"; 
   d="scan'208";a="6847431"
Message-ID: <513D4878.6040800@cn.fujitsu.com>
Date: Mon, 11 Mar 2013 10:59:04 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sysfs: Kernel OOPS  when install and remove modules
References: <513D3EA9.4010308@cn.fujitsu.com> <20130311025534.GA1185@kroah.com>
In-Reply-To: <20130311025534.GA1185@kroah.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/11 10:57:05,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/11 10:57:05,
	Serialize complete at 2013/03/11 10:57:05
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/03/11 10:55, Greg KH wrote:
> On Mon, Mar 11, 2013 at 10:17:13AM +0800, Gao feng wrote:
>> I get the below stack when I execute the shell program
>>
>> #!/bin/bash
>>
>> while :;
>> do
>> modprobe 8139too&
>> rmmod 8139too&
>> done
>>
>> I trust it is not the problem of 8139too, the other modules have the same problems too.
>> Is this an already known problem?
>>
>> [   53.328212] 8139too: 8139too Fast Ethernet driver 0.9.28
>> [   53.368029] 8139too: module is already loaded
>> [   53.456339] 8139too: 8139too Fast Ethernet driver 0.9.28
>> [   53.510611] 8139too: 8139too Fast Ethernet driver 0.9.28
>> [   53.551713] ------------[ cut here ]------------
>> [   53.551721] WARNING: at include/linux/kref.h:42 kobject_get+0x33/0x40()
>> [   53.551722] Hardware name: Bochs
>> [   53.551723] Modules linked in: 8139too(+) ebtable_nat ipt_MASQUERADE nf_conntrack_netbios_ns nf_conntrack_broadcast ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat
>> iptable_mangle nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter bnep ebtables bluetooth rfkill ip6table_filter ip6_tables be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb4i cxgb4
>> cxgb3i cxgb3 mdio libcxgbi ib_iser rdma_cm ib_addr iw_cm ib_cm ib_sa ib_mad ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device
>> snd_pcm snd_page_alloc snd_timer microcode snd i2c_piix4 virtio_balloon 8139cp soundcore mii i2c_core uinput [last unloaded: 8139too]
>> [   53.551757] Pid: 1158, comm: modprobe Not tainted 3.6.10-4.fc18.x86_64 #1
> 
> Does this happen on a kernel.org kernel release?
> 

Yes,of course,Maybe you can try the shell program,
it's easy to reproduce.

Thanks	

> There's nothing I can do with a fedora kernel, sorry.
> 
> greg k-h
> 

