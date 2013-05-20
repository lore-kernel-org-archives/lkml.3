Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294Ab3ETQCC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 12:02:02 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:39075 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab3ETQB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 12:01:59 -0400
MIME-Version: 1.0
In-Reply-To: <519A1DFD.5080809@linux.intel.com>
References: <1368586102-17661-1-git-send-email-yinghai@kernel.org>
	<20130515091248.00002fe3@unknown>
	<CAJZOPZ+L1QJdHePd_x9RAoqZKyJAKHo+hA8T1UZoe8=ozT98RA@mail.gmail.com>
	<519A1DFD.5080809@linux.intel.com>
Date: Mon, 20 May 2013 09:01:58 -0700
X-Google-Sender-Auth: 5OUPIMsWPGT8fCU7ggH89RNIirs
Message-ID: <CAE9FiQWXQhbWObM=8wq+D84sbDakChyvuze9SS0SJxuxOUeQBQ@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] PCI: Make sure VF's driver get attached after PF's
From: Yinghai Lu <yinghai@kernel.org>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: Or Gerlitz <or.gerlitz@gmail.com>, Greg Rose <gregory.v.rose@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Yan Burman <yanb@mellanox.com>, Sathya Perla <Sathya.Perla@emulex.com>,
        NetDev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 5:58 AM, Eliezer Tamir
<eliezer.tamir@linux.intel.com> wrote:
>>
> Maybe do the following:
> 1. split the VF PCI IDs into a separate PCI_ID device table.
> 2. have two pci_driver structs, one for all of the PF IDS and one with the
> VF IDS.
> 3. only register the first pci_driver struct from mlx4_init().
> 4. register the one for the VFs once your PFs are all up and ready.

that may help booting path that have driver built-in, or first time
load driver path.

For driver already loaded, and hotadd path, the problem is still there.

Yinghai
