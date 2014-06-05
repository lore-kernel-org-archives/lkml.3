Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaFENtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 09:49:46 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:31983 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbaFENto convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:49:44 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-ee-539075758346
From: Krzysztof Opasiak <k.opasiak@samsung.com>
To: "'Michal Nazarewicz'" <mina86@mina86.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>
Cc: Krzysztof Opasiak <k.opasiak@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1401954206-8491-1-git-send-email-mina86@mina86.com>
 <1401954206-8491-2-git-send-email-mina86@mina86.com>
 <008101cf80b0$caf88dc0$60e9a940$%opasiak@samsung.com>
 <xa1tvbsfmuxj.fsf@mina86.com>
In-reply-to: <xa1tvbsfmuxj.fsf@mina86.com>
Subject: RE: [PATCH 2/2] tools: ffs-test: convert to new descriptor format
 fixing compilation error
Date: Thu, 05 Jun 2014 15:49:46 +0200
Message-id: <008301cf80c5$03cfb3d0$0b6f1b70$%opasiak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+AtTJlTAm6oaScQ4ie0VGWcxLgEgABYz2w
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t/xK7qlpROCDXZv0Lc4eL/e4vbEaWwW
	l3fNYbNYtKyV2WLB8RZWB1aPdX9eMXn0bVnF6HH8xnYmj8+b5AJYorhsUlJzMstSi/TtErgy
	Fl94y1RwT79i9tqrjA2MXWpdjJwcEgImEhMWvmWFsMUkLtxbz9bFyMUhJLCUUeLp1BtQTgOT
	xIQ/fYxdjBwcbAL6EvN2iYI0iAiUSzQ9f8kCYjMLZEhMfraQCaL+PKPExiPTmEASnAJaEucv
	3GUHsYUFUiXeLT4LZrMIqErMOnSfBWQmr4CjxMtNuiBhXgFBiR+T70HNVJeYNG8RM4StLfHk
	3QVWkHIJoPijv7oQJxhJnPw2jxWiRFxi0oOH7BMYhWYhmTQLyaRZSCbNQtKygJFlFaNoamly
	QXFSeq6hXnFibnFpXrpecn7uJkZILHzZwbj4mNUhRgEORiUeXofX/cFCrIllxZW5hxglOJiV
	RHgToyYEC/GmJFZWpRblxxeV5qQWH2Jk4uCUamA0FnjnmnvlpZftjLmlBg6CWfM4Xu81uLC0
	V3mVx0V7n51+kyO3Pg2O/LVg79U/UZuOeCzJslnSpbX3xP67c02f67srpux5ciRWZunEnJ3H
	XzX+NnzmuvNqx1KO5M465fqdb6ZfFBY39Nz/bBZDpei7B1ckZffXVF03vnnUosM6ryOvWah/
	M8tbJZbijERDLeai4kQAF5cXZGMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Michal Nazarewicz [mailto:mpn@google.com] On Behalf Of Michal
> Nazarewicz
> Sent: Thursday, June 05, 2014 1:56 PM
> To: Krzysztof Opasiak; 'Felipe Balbi'
> Cc: Krzysztof Opasiak; linux-usb@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH 2/2] tools: ffs-test: convert to new descriptor
> format fixing compilation error
> 
> On Thu, Jun 05 2014, Krzysztof Opasiak <k.opasiak@samsung.com>
> wrote:
> > I would suggest adding a suitable structure as you described in
> > previous discussion[1]. Writing first 3 fields in each userspace
> > program doesn't look quite good. Using:
> >
> > #ifndef USE_LEGACY_DESC_HEAD
> > struct {
> > 	struct usb_functionfs_desc_head2 header;
> > 	__le32 fs_count
> > 	(... and rest according to flags ...)
> > } __attribute__((packed)) header;
> > #else ...
> >
> > Would be shorter, more flexible and user friendly. Moreover it
> gives
> > less places for mistake (writing fields in wrong order).
> 
> For ffs-test with USE_LEGACY_DESC_HEAD support it would be longer.
> Compare:

(... snip ...)

> 
> The second one uses an unreadable hack to match length of the first
> one
> and the third one is two lines longer.  On top of that, the second
> and
> third produce different structures, use more complicated
> preprocessing
> directives, and repeat value of fs_count and hs_count twice.
> 
> Without legacy support, it would indeed be shorter (by two lines),

Yes and I was talking about apps which use only new API without compatibility layer.

I agree that when providing compatibility layer it is more complicated but as always this is a cost of compatibility layer. 


> but
> would lead to awkward structures:
> 
> ----------- >8 ----------------------------------------------------
> -----
> struct {
> 	struct usb_functionfs_descs_head2 header;
> 	/* Why aren't the two below fields inside of a header? */
> 	__le32 fs_count;
> 	__le32 hs_count;
> };
> 
> struct {
> 	struct {
> 		/* Why is there a header.header field? */
> 		struct usb_functionfs_descs_head2 header;
> 		__le32 fs_count;
> 		__le32 hs_count;
> 	};
> };
> ----------- >8 ----------------------------------------------------
> -----
> 

Please consider this:

struct {
	struct usb_functionfs_descs_head2 header;
	__le32 fs_count;
	__le32 hs_count;
	struct {
		(...)
	} fs_desc;
	struct {
		(...) /* Other than previous */
	} hs_desc;
} = {
	.header = (...),
	.fs_count = X,
	.fs_desc = {
		(...)
	},
	.hs_count = Y,
	.hs_desc = {
		(...)
	},
}

This approach looks quite reasonable for me and don't cause any confusion. Numbers of fs and hs descriptors don't go to headers because they are more connected with fs_desc and hs_desc than with header. Using this allows you to initialize them as close to fs_desc and hs_desc as possible. BTW yes I see that when we would like to have backward compatibility this will be few lines longer.

> And I don't see how it would be more flexible.  If anything, it
> would be
> less.

When I was writing about flexibility I was talking about use case described above.

> 
> I understand, and share, your sentiment, but I don't think adding
> usb_functionfs_descs_head2 structure with magic, flags and length
> would
> improve the situation.
> 
> Something I thought about shortly was:
> 
> ----------- >8 ----------------------------------------------------
> -----
> #define USB_FFS_DESCS_HEAD(_flags) struct {				\
> 		__le32 magic, length, flags;				\
> 		__le32 data[!!(_flags & FUNCTIONFS_HAS_FS_DESC) +	\
> 			    !!(_flags & FUNCTIONFS_HAS_HS_DESC) +	\
> 			    !!(_flags & FUNCTIONFS_HAS_SS_DESC)];	\
> 	} __attribute__((packed))
> 
> #define USB_FFS_DESCS_HEAD_INIT(_flags, length, ...) {
> 	\
> 		.magic = cpu_to_le32(FUNCTIONFS_DESCRIPTORS_MAGIC_V2),
> 	\
> 		.flags = cpu_to_le32(flags),				\
> 		.langth = cpu_to_le32(length),				\
> 		.data = { __VA_ARGS__ }					\
> 	}
> 
> static const struct {
> 	USB_FFS_DESCS_HEAD(FUNCTIONFS_HAS_FS_DESC |
> FUNCTIONFS_HAS_HS_DESC),
> 	/* … */
> } __attribute__((packed)) descriptors = {
> 	USB_FFS_DESCS_HEAD_INIT(FUNCTIONFS_HAS_FS_DESC |
> FUNCTIONFS_HAS_HS_DESC,
> 				sizeof(descriptors), 3, 3),
> 	/* … */
> };
> ----------- >8 ----------------------------------------------------
> -----
> 
> But whether this is nicer is arguable as well.

In my opinion those macros are quite nice and should appear in functionfs.h. Maybe it would be suitable to provide ifdef __USB_FFS_USE_LEGACY_API and two versions of those macros? This will make backward compatibility to be handled by one switch before including a header instead of directly by user with ifndefs. Then the whole code with binary backward compatibility would be as simple as:

#ifdef MY_USE_LEGACY_FLAG
#define __USB_FFS_USE_LEGACY_API
#endif

#include <linux/usb/functionfs.h>

#define FFS_FLAGS (FUNCTIONFS_HAS_FS_DESC | FUNCTIONFS_HAS_HS_DESC)

struct {
	USB_FFS_DESCS_HEAD(FFS_FLAGS) header;
	struct {
		(...) /* descriptors */
	} fs_desc, hs_desc;
} __attribute__((packed)) my_desc = {
	.header = USB_FFS_DESCS_HEAD_INIT(FFS_FLAGS, sizeof(my_desc), 3, 3),
	(...) /* rest of initialization */
};

Of course two more suitable ifndef will be required for ss_desc. Taking all into account this approach looks very good to me and needs only minimal user action to provide support for both legacy and new API. This approach have also some disadvantage because we assume that developer has new kernel headers which provide such macros and only place where such app run has old kernel. I'm also considering approach with two macros because this would allow app to detect in runtime whether current kernel has new ffs version and use legacy macro as fallback procedure. 


--
BR's
Krzysztof Opasiak
Samsung R&D Institute Poland
Samsung Electronics
k.opasiak@samsung.com





