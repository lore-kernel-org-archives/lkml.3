Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab3KMWpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 17:45:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57111 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714Ab3KMWpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 17:45:25 -0500
Message-ID: <528400DD.3040003@zytor.com>
Date: Wed, 13 Nov 2013 14:44:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Kexec Mailing List <kexec@lists.infradead.org>,
        Baoquan He <bhe@redhat.com>, WANG Chao <chaowang@redhat.com>,
        Dave Young <dyoung@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: /proc/vmcore mmap() failure issue
References: <20131113204130.GD7613@redhat.com> <20131113210432.GE7613@redhat.com> <5283EBCD.6070305@zytor.com> <20131113224104.GF7613@redhat.com>
In-Reply-To: <20131113224104.GF7613@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2013 02:41 PM, Vivek Goyal wrote:
> 
> Hi Peter,
> 
> I noticed we seem to be trimming away partial pages in memblock.
> 
> memblock_x86_fill() {
> 	/* throw away partial pages */
>         memblock_trim_memory(PAGE_SIZE);
> }
> 
> But not in e820 hence they show up in /proc/iomem.
> 

Why does /proc/iomem matter?

> How about something along the lines as below patch. This fixes my
> /proc/vmcore mmap() issue.

I'm not sure if what you're seeing is something that is better handled
in userspace.

	-hpa


