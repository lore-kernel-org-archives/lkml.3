Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab3CUUHA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 16:07:00 -0400
Received: from [65.55.88.12] ([65.55.88.12]:6422 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752695Ab3CUUG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 16:06:58 -0400
X-Forefront-Antispam-Report: CIP:160.33.194.231;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail04v.am.sony.com;RD:mail04.sonyusa.com;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zzbb2dI98dI936eI1432I14ffIzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2fh2a8h668h839h947hd25hf0ah10d2h1288h12a5h12a9h12bdh137ah13b6h1441h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1b0ah1155h)
Message-ID: <514B67EE.8030404@am.sony.com>
Date: Thu, 21 Mar 2013 13:05:02 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "steve.glendinning@smsc.com" <steve.glendinning@smsc.com>
Subject: Re: [BUG] bisected: PandaBoard smsc95xx ethernet driver error from
 USB timeout
References: <Pine.LNX.4.44L0.1303211037070.1899-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1303211037070.1899-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/13 07:41, Alan Stern wrote:
> On Wed, 20 Mar 2013, Frank Rowand wrote:
> 
>> Hi All,
>>
>> Not quite sure quite where the problem is (USB, OMAP, smsc95xx driver, other???),
>> so casting the nets wide...
>>
>> The PandaBoard frequently fails to boot with an eth0 error when mounting
>> the root file system via NFS (ethernet driver fails due to a USB timeout;
>> no ethernet means NFS won't work).  A typical set of error messages is:
>>
>> [    3.264373] smsc95xx 1-1.1:1.0: usb_probe_interface
>> [    3.269500] smsc95xx 1-1.1:1.0: usb_probe_interface - got id
>> [    3.275543] smsc95xx v1.0.4
>> [    8.078674] smsc95xx 1-1.1:1.0: eth0: register 'smsc95xx' at usb-ehci-omap.0-1.1, smsc95xx USB 2.0 Ethernet, 82:b9:1d:fa:67:0d
>> [    8.091003] hub 1-1:1.0: state 7 ports 5 chg 0000 evt 0002
>> [   13.509918] usb 1-1.1: swapper/0 timed out on ep0out len=0/4
>> [   13.515869] smsc95xx 1-1.1:1.0: eth0: Failed to write register index 0x00000108
>> [   13.523559] smsc95xx 1-1.1:1.0: eth0: Failed to write ADDRL: -110
>> [   13.529998] IP-Config: Failed to open eth0
>>
>> I have bisected this to:
>>
>>   commit 18aafe64d75d0e27dae206cacf4171e4e485d285
>>   Author: Alan Stern <stern@rowland.harvard.edu>
>>   Date:   Wed Jul 11 11:23:04 2012 -0400
>>
>>      USB: EHCI: use hrtimer for the I/O watchdog
> 
> I don't understand how that commit could cause a timeout unless there 
> are at least two other bugs present in your system.

Yes, I would not be at all surprised if this commit merely exposes a
problem in other code.  That is why I included so many different people
and subsystems on the email distribution list.

< snip >

-Frank

