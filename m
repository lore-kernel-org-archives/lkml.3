Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882Ab3GRLwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 07:52:17 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34233 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756731Ab3GRLwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 07:52:15 -0400
Message-ID: <51E7D6E1.3000208@ti.com>
Date: Thu, 18 Jul 2013 17:22:01 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: <spi-devel-general@lists.sourceforge.net>, <grant.likely@linaro.org>,
        <balbi@ti.com>, <rnayak@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCHv2 3/3] driver: spi: Add quad spi read support
References: <1374141687-10790-1-git-send-email-sourav.poddar@ti.com> <1374141687-10790-4-git-send-email-sourav.poddar@ti.com> <20130718104414.GH22506@sirena.org.uk>
In-Reply-To: <20130718104414.GH22506@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 July 2013 04:14 PM, Mark Brown wrote:
> On Thu, Jul 18, 2013 at 03:31:27PM +0530, Sourav Poddar wrote:
>> Since, qspi controller uses quad read.
>>
>> Configuring the command register, if the transfer of data needs
>> dual or quad lines.
>>
>> This patch has been done on top of the following patch[1], which is just the
>> basic idea of adding dual/quad support in spi framework.
>> $subject patch will undergo changes as the parent patch goes[1]
>>
>> [1]: http://comments.gmane.org/gmane.linux.kernel.spi.devel/14047
> Just as with commit IDs you should include a plain text description of
> anything you link to so that people reading your e-mail can tell what
> you're talking about without going on line.
Ok, will keep that in mind for future.

Just to give you a brief description here,
Requirement is to have a dual/quad support in spi frameowrk, so that
drivers can use multiple lines for data transfers.

What patch[1] tries to does, is
[1]:  http://comments.gmane.org/gmane.linux.kernel.spi.devel/14047

is to add to each transfer the bitwidth it supports, so that that 
bitwidth information
can be parsed in controller driver and can be used for respective 
read/writes.

A typical usecase on my side is,
I have a spansion flash connected to qspi. Flash device supports quad 
read with
a certain read opcode(QUAD_READ). So, Whenever the opcode send is QUAD_READ,
we will append that information as a bitwidth to the spi transfer. This 
information will
be parsed by the controller driver and will be used to configure the cmd 
reg to do
the particular type of reads.
