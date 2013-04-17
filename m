Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966475Ab3DQOIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 10:08:48 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:33311 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966393Ab3DQOIr convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:10:1>);
	Wed, 17 Apr 2013 10:08:47 -0400
Message-Id: <516EC93D02000078000CE30A@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 17 Apr 2013 15:09:33 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "olaf@aepfle.de" <olaf@aepfle.de>, "bp@alien8.de" <bp@alien8.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "KY Srinivasan" <kys@microsoft.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH 2/3] X86: Add a check to catch Xen emulation of
 Hyper-V
References: <1359940910-32114-1-git-send-email-kys@microsoft.com>
 <1359940959-32168-1-git-send-email-kys@microsoft.com>
 <1359940959-32168-2-git-send-email-kys@microsoft.com>
 <20130417070616.GA4487@redhat.com>
 <423ae84de75f4b3587eb2d1a365cbd95@SN2PR03MB061.namprd03.prod.outlook.com>
 <516EC54A02000078000CE2AE@nat28.tlf.novell.com>
 <20130417130102.GE6801@redhat.com>
In-Reply-To: <20130417130102.GE6801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 17.04.13 at 15:01, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Wed, Apr 17, 2013 at 02:52:42PM +0100, Jan Beulich wrote:
>> >>> On 17.04.13 at 15:20, KY Srinivasan <kys@microsoft.com> wrote:
>> > If I recall correctly, the issue here was that Xen was enabling Hyper-V 
>> > emulation un-conditionally even for Linux guests.
>> 
>> To make this a little more precise - Xen is doing so only when the
>> guest config tells it to.
> 
> So it's something explicitly requested for this guest?  Then I don't
> understand why does not make sense to override it in guest.

Iirc it was/is XenServer which enable Hyper-V emulation for all HVM
guests, which clearly is the wrong thing. I was personally also not
really in agreement with the override in the kernel, but it was
decided to do it that way at that point in time. As a consequence,
I don't object this to be reverted.

Jan

