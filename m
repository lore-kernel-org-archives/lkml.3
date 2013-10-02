Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab3JBRol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:44:41 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43328 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab3JBRoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:44:39 -0400
Message-ID: <524C5B81.5040602@wwwdotorg.org>
Date: Wed, 02 Oct 2013 11:44:33 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: srinivas.kandagatla@st.com, Mark Rutland <mark.rutland@arm.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] media: rc: OF: Add Generic bindings for remote-control
References: <1380274391-26577-1-git-send-email-srinivas.kandagatla@st.com> <20130927113458.GB18672@e106331-lin.cambridge.arm.com> <52458774.1060909@st.com> <20130927105716.64349f02@samsung.com> <524935D6.1010505@st.com> <20131001114949.5a26dd70.m.chehab@samsung.com> <524C482E.3050003@st.com> <20131002143340.18639f1a@samsung.com>
In-Reply-To: <20131002143340.18639f1a@samsung.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2013 11:33 AM, Mauro Carvalho Chehab wrote:
...
> Well, from userspace PoV, it should have just one devnode for each
> TX/RX.

I'm fine with that.

> So, if the device has N TX and/or RX simultaneous connections, it should
> be exposing N device nodes, and the DT should for it should have N entries,
> one for each.

DT is based on the actual HW construction, not how a particular OS wants
to expose that HW through its APIs. If there is a single HW block, there
should be a single DT node, even if that HW block supports multiple
channels.

In some circumstances, it might make sense for the single top-level node
that represents the HW-block to have child nodes that represent the
channels, depending on what exactly the HW is doing and whether this
level of detail is useful in DT. I would qualify this as rare though.
