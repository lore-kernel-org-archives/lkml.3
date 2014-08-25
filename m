Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917AbaHYOFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:05:38 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:46736 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932510AbaHYOFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:05:35 -0400
Message-ID: <53FB42A7.3030505@gmail.com>
Date: Mon, 25 Aug 2014 10:05:27 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>
CC: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: Linux UDF support
References: <201408241446.47042@pali> <53FB2FD9.7060406@gmail.com> <201408251524.05443@pali>
In-Reply-To: <201408251524.05443@pali>
x-hashcash: 1:21:140825:pali.rohar@gmail.com::2fefbefe48b8ed433673a5f2bfd8ae00:8da2e253c2df640d
x-hashcash: 1:21:140825:jack@suse.cz::1c933e10daaa9200308bdb1571d926ce:7471439c1f776b1f
x-hashcash: 1:21:140825:linux-kernel@vger.kernel.org::d4b09cba31e6f078ff0a36239a09954e:8a6adcffb066dc20
x-stampprotocols: hashcash:1:17;mbound:0:10:3000:5000
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-08-25 09:24, Pali Rohár wrote:
> Hi,
> 
> On Monday 25 August 2014 14:45:13 Austin S Hemmelgarn wrote:
>> On 2014-08-24 08:46, Pali Rohár wrote:
>>> Hi,
>>>
>>> I would like to know what is state of linux UDF driver. It
>>> is experimental or is now suitable for storing data?
>>
>> I know that read support works for every version I have
>> tested, but I've only tested it reading data from DVD's and
>> Blu-Ray discs, so I don't know how well it works for other
>> purposes.
>>
> 
> Ok. I'm thinking about using UDF on HDD and usb flash disks (not 
> on optical medium). And here I need write support too.
> 
>>> According to wikipedia [1] UDF has open specification format
>>> and can be used also for HDDs (not only optical discs).
>>>
>>> In OS support table is written that all major and other
>>> minor OSs support UDF FS (without needs for additional
>>> programs).
>>>
>>> So it looks like UDF is good candidate for multi OS
>>> filesystem. Are there any disadvantages for using UDF on
>>> e.g USB flash disk? (when I want read/write support on
>>> Linux, Windows 7 and Mac OS X)
>>
>> If you are going to go that way, make sure to use the Spared
>> Build, as otherwise you will run in to the same media
>> wear-out issues that NTFS and FAT have.  Also, keep in mind
>> that pre-Vista Windows and pre-10.4 OSX don't have very good
>> support for the newer formats.
>>
> 
> What is Spared Build? And how to use it?
Sparse Build is one of the extensions that was added in 1.50.  It
provides a table indicating sectors that have worn out and therefore
should be left unused.  The general idea is that rewritable media is
almost always limited in the number of writes it can handle to a given
location, and when you exceed that number, you get data corruption at
that location.  This is usually most noticeable on flash media, but it
happens on {CD,DVD,BD}-RW discs and hard drives as well.  FAT has no
provisions for handling this, and NTFS and ext4 just return the
corrupted data.  UDF however, has sufficient error correction ability
(because it was designed with optical media in mind) that it can usually
detect the corruption, recover the corrupted data, and then if you are
using the Sparse Build format, mark that block as unusable, and write
the new data out elsewhere.
> 
> Problem with NTFS is that linux driver has write support marked 
> as experimental. FAT has problems with big files and for exFAT 
> there is no driver in linux kernel yet...
> 
For NTFS, you should be using NTFS-3G, not the kernel driver, and I
personally wouldn't trust the OS X driver for NTFS for anything beyond
read-only usage (I only barely trust NTFS-3G as it is, and have about as
much trust in the Linux kernel driver for it as I would in somebody
trying to convince me that arsenic is good for you).  And for exFAT
there is FUSE module.  I haven't tested either for much other than
read-only scenarios, but I can confirm that they are great for data
recovery.
>>> Because lot of manuals say that FAT32 (or NTFS) is only one
>>> solution for using USB flash disk on more OS.
>>>
>>> On wikipedia there is one note about linux: Write support is
>>> only up to UDF version 2.01. Is this restriction still
>>> valid?
>>
>> I do know that we support reading UDF 2.60 (I've used linux to
>> read Blu-Ray discs), but I have no idea about write support
>> for versions above 2.01.
>>
>>> What will happen if I try to mount FS with UDF version 2.60
>>> in R/W mode on linux? It will fallback to R/O mode? Or
>>> newly written files will be in previous (2.01) versions?
>>>
>>> And last question: Is there some fsck tool for UDF? Or at
>>> least tool which print if FS is in inconsistent state?
>>
>> Most Linux distributions have a package called udftools, the
>> upstream URL given by portage is
>> http://sf.net/projects/linux-udf/
>>
> 
> That project does not have udf fsck tool :-(
IIRC, there are a lot of issues that UDF will recover from gracefully.
It has ridiculously good error correction abilities, and the newer
versions even have the option of duplicate copies of filesystem metadata
to provide even more resilience.
> 
>>> [1] - http://en.wikipedia.org/wiki/Universal_Disk_Format
> 
> Ok, I will wait for response from maintainer Jan, he probably 
> would know more...
> 

