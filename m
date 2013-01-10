Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab3AJWFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 17:05:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:48455 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab3AJWF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 17:05:29 -0500
Message-ID: <50EF3B6A.70704@infradead.org>
Date: Thu, 10 Jan 2013 14:06:34 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: linux-next: Tree for Jan 10 (staging/sb105x)
References: <20130110143241.041ef77011ef7b1f68ae5c61@canb.auug.org.au>  <50EF11B2.9090505@infradead.org> <1357851057.5141.16.camel@gandalf.local.home>
In-Reply-To: <1357851057.5141.16.camel@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/13 12:50, Steven Rostedt wrote:
> On Thu, 2013-01-10 at 11:08 -0800, Randy Dunlap wrote:
>> On 01/09/13 19:32, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20130109:
>>>
>>
>> on x86_64, when CONFIG_PARPORT_PC is not enabled:
>>
>> drivers/built-in.o: In function `multi_init':
>> sb_pci_mp.c:(.init.text+0x15684): undefined reference to `parport_pc_probe_port'
>>
>>
>> Full randconfig file is attached.
> 
> Ug, so https://lkml.org/lkml/2012/12/14/250 should have been
> CONFIG_PARPORT_PC and not just PARPORT :-P
> 
> Can you try this patch:

That's good.  Thanks.

Acked-by: Randy Dunlap <rdunlap@infradead.org>


> diff --git a/drivers/staging/sb105x/sb_pci_mp.c b/drivers/staging/sb105x/sb_pci_mp.c
> index 131afd0c..9464f38 100644
> --- a/drivers/staging/sb105x/sb_pci_mp.c
> +++ b/drivers/staging/sb105x/sb_pci_mp.c
> @@ -3054,7 +3054,7 @@ static int init_mp_dev(struct pci_dev *pcidev, mppcibrd_t brd)
>  				sbdev->nr_ports = ((portnum_hex/16)*10) + (portnum_hex % 16);
>  			}
>  			break;
> -#ifdef CONFIG_PARPORT
> +#ifdef CONFIG_PARPORT_PC
>  		case PCI_DEVICE_ID_MP2S1P :
>  			sbdev->nr_ports = 2;
>  
> 
> 
> --


-- 
~Randy
