Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823AbaJ2HzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 03:55:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:58994 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843AbaJ2HzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 03:55:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,808,1406617200"; 
   d="scan'208";a="622614910"
From: Jani Nikula <jani.nikula@intel.com>
To: Michael Ellerman <mpe@ellerman.id.au>,
        Randy Dunlap <rdunlap@infradead.org>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-fbdev@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        Daniel Drake <dsd@laptop.org>, Jens Frederich <jfrederich@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jon Nettleton <jon.nettleton@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        platform-driver-x86@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Darren Hart <dvhart@infradead.org>,
        Daniel Vetter <daniel.vetter@intel.com>, Bryan Wu <cooloney@gmail.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] drivers: depend on instead of select BACKLIGHT_CLASS_DEVICE and ACPI_VIDEO
In-Reply-To: <1414551853.7417.1.camel@concordia>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <1413580403-16225-1-git-send-email-jani.nikula@intel.com> <54476492.6090105@ti.com> <87a94hu3j0.fsf@intel.com> <544E44E9.4040208@ti.com> <544FFC91.9040104@infradead.org> <1414551853.7417.1.camel@concordia>
User-Agent: Notmuch/0.18.1+133~g83c61fa (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 29 Oct 2014 09:54:36 +0200
Message-ID: <87tx2njooz.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2014, Michael Ellerman <mpe@ellerman.id.au> wrote:
> On Tue, 2014-10-28 at 13:29 -0700, Randy Dunlap wrote:
>> On 10/27/14 06:13, Tomi Valkeinen wrote:
>> > I also think the 'depends on BACKLIGHT_CLASS_DEVICE ||
>> > BACKLIGHT_CLASS_DEVICE=n' pattern is quite... interesting (i.e. sounds
>> > like a hack to me =).
>> 
>> It does exactly what is needed and it is used in many places in kernel
>> Kconfig files.
>
> Is there any reason you can't do:
>
>   depends on BACKLIGHT_CLASS_DEVICE != m

That's not the same thing. The FOO || FOO=n allows for all options, but
forbids it being a module when the option depending on it is
built-in. Obviously something that's built-in can't depend on something
built as a module.

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
