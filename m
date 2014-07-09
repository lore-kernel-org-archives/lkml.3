Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbaGIHW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 03:22:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbaGIHW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 03:22:57 -0400
Message-ID: <53BCEDAF.8090308@redhat.com>
Date: Wed, 09 Jul 2014 09:22:23 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>,
        =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>
CC: sebastian.hesselbarth@gmail.com, kishon@ti.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 3/7] ata: libahci: allow to use multiple PHYs
References: <1404728173-20263-1-git-send-email-antoine.tenart@free-electrons.com> <1404728173-20263-4-git-send-email-antoine.tenart@free-electrons.com> <20140708134000.GC4979@htj.dyndns.org>
In-Reply-To: <20140708134000.GC4979@htj.dyndns.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/08/2014 03:40 PM, Tejun Heo wrote:
> (Cc'ing Hans.)

Thanks for adding me to the loop.

I've been reading the entire thread sofar, and here are my 2 cents:

1) I think overall this is a good idea, and I like the suggested dt representation
2) I agree with Tejun that it would be better to tie the phy to the port, and thus to
add the struct phy * pointer to struct ahci_port_priv.

One question 2 brings with it is how to deal with older device-tree files which
have the phy directly in the ahci controller node. This seems to only be the
case for the TI dra7 and omap5 platforms. Probably those have only 1 sata port
(this needs to be verified), if that is the case we can simply hard code
tying the phy to port 0 in this case, and we should probably also update their
dts files in the kernel tree to use the new structure (while keeping the
ahci driver compatible with the old structure for now).

Regards,

Hans


