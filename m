Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab3GSU61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 16:58:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48205 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354Ab3GSU60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 16:58:26 -0400
Message-ID: <51E9A85D.2060206@zytor.com>
Date: Fri, 19 Jul 2013 13:58:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Daniel Kiper <daniel.kiper@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Eric Biederman <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Brandon Philips <brandon@ifup.org>, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: Re: is kexec on Xen domU possible?
References: <20130719020603.GA22932@kroah.com> <20130719131819.GC11233@debian70-amd64.local.net-space.pl> <20130719151243.GA15488@kroah.com> <20130719183235.GA12267@debian70-amd64.local.net-space.pl> <20130719191449.GA1882@kroah.com>
In-Reply-To: <20130719191449.GA1882@kroah.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 12:14 PM, Greg KH wrote:
>>
>>> The errors that the kexec tools seem to run into is finding the memory
>>> to place the new kernel into, is that just an issue that PV guests
>>> aren't given enough kernel memory in which to replicate themselves from
>>> dom0?
>>
>> There are a lot of differences between baremetal machines and PV guests.
>> For example you are not able to do identity mapping per se in PV guests.
>> Arguments to new kernel are passed in completely different way. etc.
> 
> Ok, thanks for confirming that it is possible, but doesn't currently
> work for pv guests.
> 

Also, in any virtualized environment the hypervisor can do a better job
for things like kdump, simply because it can provide two things that are
otherwise hard to do:

1. a known-good system state;
2. a known-clean kdump image.

As such, I do encourage the virtualization people to (also) develop
hypervisor-*aware* solutions for these kinds of things.

	-hpa


