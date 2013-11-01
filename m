Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab3KAMJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 08:09:23 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:61919 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab3KAMJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 08:09:21 -0400
MIME-Version: 1.0
In-Reply-To: <20131101111020.GD18477@ns203013.ovh.net>
References: <1380732056-5387-1-git-send-email-dh.herrmann@gmail.com>
	<20131031104549.GZ18477@ns203013.ovh.net>
	<CANq1E4QAwOG8Vdw2nCb8+LirZ278w58j+wpieeKvnNepga+baw@mail.gmail.com>
	<20131101111020.GD18477@ns203013.ovh.net>
Date: Fri, 1 Nov 2013 13:09:20 +0100
Message-ID: <CANq1E4SWmKQp9y+8ay4q3zK=XTwAekNnmNeeR6VVut75PRbs=Q@mail.gmail.com>
Subject: Re: [PATCH v2] efifb: prevent null-deref when iterating dmi_list
From: David Herrmann <dh.herrmann@gmail.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        James Bates <james.h.bates@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        James Bates <james.h.bates@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, Nov 1, 2013 at 12:10 PM, Jean-Christophe PLAGNIOL-VILLARD
<plagnioj@jcrosoft.com> wrote:
> On 17:17 Thu 31 Oct     , David Herrmann wrote:
>> Hi
>>
>> On Thu, Oct 31, 2013 at 11:45 AM, Jean-Christophe PLAGNIOL-VILLARD
>> <plagnioj@jcrosoft.com> wrote:
>> > On 18:40 Wed 02 Oct     , David Herrmann wrote:
>> >> The dmi_list array is initialized using gnu designated initializers, and
>> >> therefore may contain fewer explicitly defined entries as there are
>> >> elements in it. This is because the enum above with M_xyz constants
>> >> contains more items than the designated initializer. Those elements not
>> >> explicitly initialized are implicitly set to 0.
>> >>
>> >> Now efifb_setup() loops through all these array elements, and performs
>> >> a strcmp on each item. For non explicitly initialized elements this will
>> >> be a null pointer:
>> >>
>> >> This patch swaps the check order in the if statement, thus checks first
>> >> whether dmi_list[i].base is null.
>> >>
>> >> Signed-off-by: James Bates <james.h.bates@yahoo.com>
>> >> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
>> >
>> > with the simpleDRM arriving next merge I'm wondering if we need to keep it?
>>
>> SimpleDRM is not coming next merge-window. It's basically finished,
>> but I'm still working on the user-space side as its KMS api is highly
>> reduced compared to fully-featured DRM/KMS drivers. Maybe 3.13 will
>> work out.
>
> do you have a git tree for the simpleDRM that I can pull?

Sure, I usually push it to my fdo tree:
  http://cgit.freedesktop.org/~dvdhrm/linux/log/?h=simpledrm
But note that you shouldn't be using it right now. User-space fails on
it as SimpleDRM only provides a single KMS-FB. It also needs to be
adjusted to the new x86-sysfb changes and I am reworking the handover
to real drivers.

Cheers
David
