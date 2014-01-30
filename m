Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbaA3MKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 07:10:46 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:52335 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbaA3MKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 07:10:45 -0500
Message-ID: <52EA412F.7070005@ti.com>
Date: Thu, 30 Jan 2014 17:40:23 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Pratyush Anand <pratyush.anand@st.com>
CC: Mohit KUMAR DCG <Mohit.KUMAR@st.com>, "arnd@arndb.de" <arnd@arndb.de>,
        spear-devel <spear-devel@list.st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH V3 4/8] phy: Initialize phy core with subsys_initcall
References: <cover.1391077731.git.mohit.kumar@st.com> <6f2dbd4fcb99a070c07b39545d98eca58101daa0.1391077731.git.mohit.kumar@st.com> <52EA3AE9.3030000@ti.com> <20140130115212.GA1171@pratyush-vbox>
In-Reply-To: <20140130115212.GA1171@pratyush-vbox>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 30 January 2014 05:22 PM, Pratyush Anand wrote:
> On Thu, Jan 30, 2014 at 07:43:37PM +0800, Kishon Vijay Abraham I wrote:
>> Hi,
>>
>> On Thursday 30 January 2014 04:18 PM, Mohit Kumar wrote:
>>> From: Pratyush Anand <pratyush.anand@st.com>
>>>
>>> PCIe RC drivers are initialized with subsys_initcall. Few PCIe drivers
>>> like SPEAr13xx needs phy drivers to be initialized.
>>
>> Instead change PCIe RC drivers to module init. Phy drivers should be loaded
>> very early otherwise. (Hint: drivers/Makefile).
> 
> I think PCIe RC driver can not be made module init. Bjorn can comment
> better.

Why not? I have used it for DRA7xx without any issues (I'll send that one
upstream once the PIPE3 phy part gets clear).
> 
> All PCIe card drivers are initialized with module init. RC driver must
> have been initialized before any card driver initialization.
> Currently, card drivers does not have deferred probe concept, so I am
> not sure if keeping RC driver as module init will work always.

the card drivers will anyway be probed only after RC driver comes up no?
> 
> By the way, is there any side effect of loading phy driver very early?

I assume you meant 'is there any side effect of using subsys_initcall?', since
phy driver is loaded early anyway.
The answer is no just that module_init is common one and more people prefer to
use module_init. (btw initial versions of phy-core had susbsys_initcall before
it got changed to use module_init)

Thanks
Kishon
