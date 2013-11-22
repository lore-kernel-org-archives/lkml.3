Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab3KVPZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:25:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40144 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755783Ab3KVPZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:25:28 -0500
Message-ID: <528F7735.9010209@zytor.com>
Date: Fri, 22 Nov 2013 07:24:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, mjg59@srcf.ucam.org
Subject: Re: [PATCH 5/6] kexec-bzImage: Support for loading bzImage using
 64bit entry
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com> <1384969851-7251-6-git-send-email-vgoyal@redhat.com> <20131121190710.GD17070@kroah.com> <20131121192114.GN16208@redhat.com>
In-Reply-To: <20131121192114.GN16208@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2013 11:21 AM, Vivek Goyal wrote:
>>
>> What do you mean by the "real mode entry"?  Do we need to care about
>> that because we aren't falling back to real mode when executing this,
>> are we?  Or does that just happen for 32bit kernels?
> 
> Original kexec offers real mode entry choice too. So we fall back
> to real mode and jump to kernel and kernel makes bunch of BIOS calls. I
> don't think this is a commonly used option.
> 

I know some users of it (who I shall not name.)  In general it is a bad
option, because after running the first kernel the state of the hardware
is not guaranteed to be such that executing the BIOS is safe.  In
general, I do think they do it just because they tried at some point and
it happened to work; discouraging its use is probably for the better.

	-hpa

