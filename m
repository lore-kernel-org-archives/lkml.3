Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053AbaH0Hio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 03:38:44 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:37627 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731AbaH0Hih convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Wed, 27 Aug 2014 03:38:37 -0400
Message-Id: <53FDA71B020000780002DF2E@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Wed, 27 Aug 2014 08:38:35 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Dexuan Cui" <decui@microsoft.com>
Cc: "jeremy@goop.org" <jeremy@goop.org>, "KY Srinivasan" <kys@microsoft.com>,
        "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sync_set_bit() vs set_bit()  -- what's the difference?
References: <EE124450C0AAF944A40DD71E61F878C99639F3@SINEX14MBXC419.southpacific.corp.microsoft.com>
In-Reply-To: <EE124450C0AAF944A40DD71E61F878C99639F3@SINEX14MBXC419.southpacific.corp.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 27.08.14 at 09:30, <decui@microsoft.com> wrote:
> I'm curious about the difference. :-)
> 
> sync_set_bit() is only used in drivers/hv/ and drivers/xen/ while set_bit() 
> is used in all other places. What makes hv/xen special?

I guess this would really want to be used by anything communicating
with a hypervisor or a remote driver: set_bit() gets its LOCK prefix
discarded when the local kernel determines it runs on a single CPU
only. Obviously having knowledge of the CPU count inside a VM does
not imply anything about the number of CPUs available to the host,
i.e. stripping LOCK prefixes in that case would be unsafe.

Jan

