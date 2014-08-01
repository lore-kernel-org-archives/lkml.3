Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbaHARVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 13:21:18 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:36013 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754958AbaHARVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 13:21:16 -0400
Message-ID: <1406913674.22529.45.camel@hornet>
Subject: Re: [PATCH 5/5] platform: Make platform_bus device a platform device
From: Pawel Moll <pawel.moll@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@wwwdotorg.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "paul@pwsan.com" <paul@pwsan.com>, Arnd Bergmann <arnd@arndb.de>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 01 Aug 2014 18:21:14 +0100
In-Reply-To: <20140726201240.GB21870@kroah.com>
References: <1406298233-27876-1-git-send-email-pawel.moll@arm.com>
	 <1406298233-27876-5-git-send-email-pawel.moll@arm.com>
	 <20140726201240.GB21870@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-07-26 at 21:12 +0100, Greg Kroah-Hartman wrote:
> On Fri, Jul 25, 2014 at 03:23:53PM +0100, Pawel Moll wrote:
> > ... describing the root of the device tree, so one can write
> > a platform driver initializing the platform.
> 
> Wait, what do you mean by "one can write a platform driver initializing
> the platform"?  I don't understand your end goal here...

Bad wording, sorry. The goal is to have a platform driver (as in
platform bus) that will initialize my platform (as in: board, machine,
hardware). My platform (as in: the board) will be represented by the
root platform bus device (as in: the bus ;-) with compatible value
matching the one passed in the device tree's root.

The tree:

8<----------------------------
/ {
	compatible = "my,board";
}
8<----------------------------

The driver:

8<----------------------------
static struct of_device_id my_board_match[] = {
        { .compatible = "my,board", },
        {},
};

static struct platform_driver my_board_driver = {
        .driver = {
                .name = "my_board",
                .owner = THIS_MODULE,
                .of_match_table = of_match_ptr(my_board_match),
        },
        .probe = my_board_probe,
        .remove = my_board_remove,
};
module_platform_driver(my_board_driver);
8<----------------------------

I'll work on better commit message for the next spin.

Paweł


