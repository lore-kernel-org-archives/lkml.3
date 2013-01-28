Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab3A1MjH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 07:39:07 -0500
Received: from mga05.intel.com ([192.55.52.89]:39136 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755489Ab3A1MjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 07:39:04 -0500
Message-ID: <1359376730.8282.20.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [RFC] efivars write(2) races
From: Matt Fleming <matt.fleming@intel.com>
To: Lingzhu Xiang <lxiang@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeremy Kerr <jeremy.kerr@canonical.com>
Date: Mon, 28 Jan 2013 12:38:50 +0000
In-Reply-To: <5105E4A3.9040102@redhat.com>
References: <20130125002552.GC4503@ZenIV.linux.org.uk>
	  <51020120.5000500@redhat.com>
	 <1359119883.2496.156.camel@mfleming-mobl1.ger.corp.intel.com>
	 <5105E4A3.9040102@redhat.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-28 at 10:38 +0800, Lingzhu Xiang wrote:
> On 01/25/2013 09:18 PM, Matt Fleming wrote:
> >> 4. EFI_VARIABLE_APPEND_WRITE with EFI_OUT_OF_RESOURCES truncates size but you
> >>     can still read its content.
> >
> > I'm not sure what you mean by this. Could you please explain?
> 
> Oops, this one is incorrect. I was testing EFI_VARIABLE_APPEND_WRITE
> using this:
> 
> printf "\x47\x00\x00\x00\x00" >test-1-$guid
> 
> So it truncates the file before writing, but efivarfs figures out the right
> size afterwards. The size remains zero if the write fails.
> 
> I should be using this for appending:
> 
> printf "\x47\x00\x00\x00\x00" >>test-1-$guid

Does this mean that these two test cases work as expected?

