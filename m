Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab3EHQb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:31:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55039 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667Ab3EHQbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:31:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [RFC 1/8] serial:st-asc: Add ST ASC driver.
Date: Wed, 8 May 2013 18:31:48 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Will Deacon <will.deacon@arm.com>, jslaby@suse.cz,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, Nicolas Pitre <nico@linaro.org>,
        linux-doc@vger.kernel.org,
        Stephen Gallimore <stephen.gallimore@st.com>,
        linux-serial@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Stephen Warren <swarren@nvidia.com>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com> <B5A00B86-5332-427E-A82A-5B71EC0979A8@jcrosoft.com> <20130508161527.GA28080@kroah.com>
In-Reply-To: <20130508161527.GA28080@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305081831.48566.arnd@arndb.de>
X-Provags-ID: V02:K0:SJzUXqtSr23faPhhqgo92WWwk4jOObExeQIWaHfbUqe
 UhnoKQuVo5KnSEVVkz24vgE+zuZMdXbit/iBZ/Q8NorVQtNe+0
 U+naIVPztu8JdlhAdMSF29bVSlcMLSkG/P1qmz2ujmTHjPhyT8
 IkW3FCA9MQiTUgfs42f3OxUVAUYdLqSJpGcWPKvuB6lTOjm3eP
 xlScuBdQ2KQkeD67SDi172LYNv+wNQvAUCMqdEEDA5D1jXOYWq
 ySDS1rwDzTrYPUZnh9e8h28MYnY0JHyZtNwJxSredPzt+OItFB
 DImImbGJPtFyp6l4gQm02Imy+C4vajhgVSfWzzmUb2w9pgylXG
 UPv/755YkIlGZ8mxuCyo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 May 2013, Greg KH wrote:
> > just mention there is not hardware reason to not use the generic ttySx
> > in place of ttyAS as we have only one IP that handle serial on this
> > family of SoC
> > 
> > personally I'll switch to ttySx
> 
> Great, then you can use the same major/minor range as well, so there's
> no more objection from me about this :)

Does that work these days when you have kernel with multiple built-in
uart drivers?

I think it would be good if all uarts were using the same name space
and major/minor numbers, but I think the mess we currently have is
the result of the tty_register_driver() interface reserving the
device number range at driver load time, independent of the presence
of devices.  I would assume that normal distro kernels always ship
with an 8250 driver built-in to allow using that as the console,
and if I read the code correctly, that currently prevents another
uart driver from registering the same major/minor numbers.

	Arnd
