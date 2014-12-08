Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbaLHTmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 14:42:21 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:44547 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbaLHTmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 14:42:19 -0500
Message-ID: <5485FF17.1070504@gmail.com>
Date: Mon, 08 Dec 2014 21:42:15 +0200
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>,
        =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>
CC: Marcel Holtmann <marcel@holtmann.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ming Lei <ming.lei@canonical.com>, Pavel Machek <pavel@ucw.cz>,
        "John W. Linville" <linville@tuxdriver.com>,
        Grazvydas Ignotas <notasas@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Kalle Valo <kvalo@adurom.com>,
        Sebastian Reichel <sre@ring0.de>,
        David Gnedt <david.gnedt@davizone.at>
Subject: Re: wl1251: NVS firmware data
References: <201411271506.20457@pali> <201412081811.46943@pali>	 <30072B9E-2495-4F90-AC91-9C0D7E08F44E@holtmann.org>	 <201412082015.18501@pali> <1418066813.1350.18.camel@dcbw.local>
In-Reply-To: <1418066813.1350.18.camel@dcbw.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On  8.12.2014 21:26, Dan Williams wrote:
>
> a) change driver to prefer a new "wl1251-nvs-n900.bin" file, but fall
> back to "wl1251-nvs.bin" if the first one isn't present
> b) have a "wl1251-cal-nvs-update" service that, if wl1521-nvs-n900.bin
> is *not* present mounts the CAL MTD, reads the data, writes it out into
> wl1521-nvs-n900.bin, and the rmmod/modprobes the driver
>
> and done?  Stuff that's not N900 just wouldn't ship the update service
> and would proceed like none of this happened.
>
> Dan
>
>

That would mean that the driver should not be built-in, as afaik we 
cannot rmmod built-in drivers. Sure, it will work after a reboot, but 
this is a bit hacky, agree?

Also, new NVS file needs to be loaded when fcc regulation changes(flying 
abroad), so that would mean that the device would be outside of those 
until reboot (in case of built-in driver)

Ivo
