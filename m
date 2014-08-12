Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbaHLQVD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 12:21:03 -0400
Received: from mtaout22.012.net.il ([80.179.55.172]:52915 "EHLO
	mtaout22.012.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbaHLQVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 12:21:00 -0400
Date: Tue, 12 Aug 2014 19:20:52 +0300
From: Oren Twaig <oren@scalemp.com>
Subject: Re: x86: vmalloc and THP
In-reply-to: <20140812060745.GA7987@node.dhcp.inet.fi>
X-012-Sender: ira_oren@012.net.il
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org,
        "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>
Message-id: <53EA3EE4.6090100@scalemp.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Antivirus: avast! (VPS 140812-0, 08/12/2014), Outbound message
X-Antivirus-Status: Clean
References: <53E99F86.5020100@scalemp.com> <20140812060745.GA7987@node.dhcp.inet.fi>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kirill,

I saw the thread has developed nicely :), still - wanted to answer your 
question
below.

On 8/12/2014 9:07 AM, Kirill A. Shutemov wrote:
> On Tue, Aug 12, 2014 at 08:00:54AM +0300, Oren Twaig wrote:
>> <html style="direction: ltr;">
> plain/text, please.
Yes - noticed the html, sent again in plain text.
>> If not, is there any fast way to change this behavior ? Maybe by
>> changing the granularity/alignment of such allocations to allow such
>> mapping ?
> What's the point to use vmalloc() in this case?
I've noticed that some lock/s are using linear addresses which are
located at 0xffffc901922b4500 and from what I understand
from mm.txt (kernel 3.0.101):
*ffffc90000000000 - ffffe8ffffffffff (=45 bits) vmalloc/ioremap space

*So I'm not sure who/how/why this lock got allocated there, but obviously
it is using that linear set. No ?

>


---
This email is free from viruses and malware because avast! Antivirus protection is active.
http://www.avast.com

