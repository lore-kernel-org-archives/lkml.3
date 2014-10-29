Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbaJ2G7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 02:59:12 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:42743 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751773AbaJ2G7L convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 02:59:11 -0400
Subject: Re: [PATCH] configfs: Implement binary attributes (v3)
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Content-Type: text/plain; charset=utf-8
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20141029025418.GA7842@kroah.com>
Date: Wed, 29 Oct 2014 08:58:59 +0200
Cc: Joel Becker <jlbec@evilplan.org>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <E9EEA8B1-BB55-4384-9884-0153AFA9D128@antoniou-consulting.com>
References: <1414528232-7707-1-git-send-email-pantelis.antoniou@konsulko.com> <20141029025418.GA7842@kroah.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1990.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

> On Oct 29, 2014, at 04:54 , Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> On Tue, Oct 28, 2014 at 10:30:32PM +0200, Pantelis Antoniou wrote:
>> ConfigFS lacked binary attributes up until now. This patch
>> introduces support for binary attributes in a somewhat similar
>> manner of sysfs binary attributes albeit with changes that
>> fit the configfs usage model.
>> 
>> Problems that configfs binary attributes fix are everything that
>> requires a binary blob as part of the configuration of a resource,
>> such as bitstream loading for FPGAs, DTBs for dynamically created
>> devices etc.
> 
> What's wrong with using the firmware interface for this instead?
> 

It is problem when the bitstream is provided by user-space due to namespace
issues. What happens if you have a container, from where do you get that firmware
file so that you can use it.

IIRC Joel didn’t object too much last time I posted it.

> What driver/subsystem wants to use configfs binary files?  Having a user
> for this api is essential if you want it to be merged.
> 

Device tree overlays for starters and the FPGA manager.

For the first please look at "OF: DT-Overlay configfs interface (v2)” posted
yesterday; you are in the CC list.

> thanks,
> 
> greg k-h

Regards

— Pantelis

