Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342Ab3HMAjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 20:39:12 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:11499 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059Ab3HMAjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 20:39:10 -0400
Message-ID: <1376354275.10300.361.camel@misato.fc.hp.com>
Subject: Re: [PATCH] driver core / cpu: Check if NUMA node is valid before
 bringing CPU up
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        rafael.j.wysocki@intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wen Congyang <wency@cn.fujitsu.com>
Date: Mon, 12 Aug 2013 18:37:55 -0600
In-Reply-To: <12747916.Y6ImPYErWR@vostro.rjw.lan>
References: <5200CBBF.1090904@jp.fujitsu.com>
	 <33585791.CVfk6FmZRF@vostro.rjw.lan>
	 <1376338103.10300.336.camel@misato.fc.hp.com>
	 <12747916.Y6ImPYErWR@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-13 at 02:39 +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> There is a potential race condition between cpu_subsys_online()
> and either acpi_processor_remove() or remove_memory() that execute
> try_offline_node().  Namely, it is possible that cpu_subsys_online()
> will run right after the CPUs NUMA node has been put offline and
> cpu_to_node() executed by it will return NUMA_NO_NODE (-1).  In
> that case the CPU is gone and it doesn't make sense to call cpu_up()
> for it, so make cpu_subsys_online() return -ENODEV then.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Acked-by: Toshi Kani <toshi.kani@hp.com>
> ---
> 
> Hi Greg,
> 
> Can you please kindly queue up this one for 3.12?
> 
> I've added the Toshi's ACK as he said it looked good to him. :-)

That's fine by me.
-Toshi

