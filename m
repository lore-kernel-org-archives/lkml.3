Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab3KKKyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 05:54:51 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:48626 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752942Ab3KKKyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 05:54:43 -0500
Date: Mon, 11 Nov 2013 10:54:24 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Richard Weinberger <richard@nod.at>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, matt.fleming@intel.com,
        matthew.garrett@nebula.com, jlee@suse.com
Subject: Re: [PATCH] x86, efi: change name of efi_no_storage_paranoia
 parameter to efi_storage_paranoia
Message-ID: <20131111105424.GD22636@console-pimps.org>
References: <527C93B5.7010407@jp.fujitsu.com>
 <527C9B5C.6040509@nod.at>
 <527CB013.30200@jp.fujitsu.com>
 <527CB0F4.8080606@nod.at>
 <527CBC05.6080505@jp.fujitsu.com>
 <527CBD01.1000908@nod.at>
 <527CBDD3.2020609@jp.fujitsu.com>
 <20131108143421.GB22636@console-pimps.org>
 <52809AEB.9080100@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52809AEB.9080100@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Nov, at 05:52:59PM, Yasuaki Ishimatsu wrote:
> Hi Matt,
> 
> I uses FUJITSU's x86 box.
> This does not become bricked even if I use all efi variable storage.
> Thus I want a way to not need to specify efi_no_storage_paranoia
> parameter.

The efi_no_storage_paranoia parameter was introduced because some
machines do not initiate garbage collection of the NVRAM until you
allocate all space - basically it's a switch to turn off the "save 5KB
of stoarge at all times" workaround that is needed to avoid bricking
some machines. 

The intention of the switch is not to allow you to fill your NVRAM just
because you can. If that is something you want to do then I think it's
fair to require you to explicitly turn on efi_no_storage_paranoia. But
I'm assuming here that you are doing something like writing lots and
lots of pstore entries and just want to write as many as your variable
storage will allow? Or are you doing something more fundamental like
creating BootXXXX entries?

What are you doing to run into the 5KB reserve? How much NVRAM does your
machine come with?

-- 
Matt Fleming, Intel Open Source Technology Center
