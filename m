Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbaKDQ0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:26:22 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:52400 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbaKDQ0R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:26:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Grant Likely <grant.likely@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rob Herring <robherring2@gmail.com>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sagar Dharia <sdharia@codeaurora.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 0/1] Compact interface for Device-Tree
Date: Tue, 04 Nov 2014 17:25:58 +0100
Message-ID: <4742258.TBitC3hVuO@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141104155329.A23A5C423D0@trevor.secretlab.ca>
References: <1414709964-27284-1-git-send-email-gavidov@codeaurora.org> <40803956.DTL7dD7CLv@wuerfel> <20141104155329.A23A5C423D0@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:0S4QdA1zgXSEuJ09tR6CjW+4UV94sf8dfw0DMMmM+5H
 2k4eCcAZEI4fGjvvc9NIMqIFg56H/nPeYz0XqmU11tawewa8eu
 yaZbPDwdeBfhLAwBeyDKf8n8XZNuYOA79BtZZMUuSt19bruZ6E
 BO0Ze3vbP5kYHwUpMZGlw4SjRsgnPOFYlb/X5EYRIoTHA4kj+K
 AfdlHpLNvM2qEQUMDXwa5fQsTT7mSpoICGzceaLEzGoHqz0l31
 PtVHQhacIk1CZLfH0qF2n6z1blyzAvg9NBOOPAIm3Ah/zrxenH
 sIcNSNVJ8WJ7x3dRkbJHI4sC7VEYuzJOJ9XaxuoaQuJT9BoOvG
 ZiiQbbqhQoEqhQxFd6bg=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 November 2014 15:53:29 Grant Likely wrote:
> On Mon, 03 Nov 2014 16:06:03 +0100
> , Arnd Bergmann <arnd@arndb.de>
>  wrote:
> > On Friday 31 October 2014 23:53:28 Rafael J. Wysocki wrote:
> > > On Saturday, November 01, 2014 05:13:45 AM Rob Herring wrote:
> > > > On Fri, Oct 31, 2014 at 6:59 AM, Gilad Avidov <gavidov@codeaurora.org> wrote:
> > > > >
> > > > > Device-Tree compact API
> > > > > ------------------------
> > > > >
> > > > > Common code seen in driver’s probe reads device tree values and handling
> > > > > erroneous return codes from all those of_property_read_xxx()  APIs. This
> > > > > common code is factored out by the of_property_map module which allows
> > > > > driver’s probe to replace that (often lengthy) code with a concise table:
> > > > >
> > > > > struct of_prop_map map[] = {
> > > > >     {"i2c",            &dev->id,        OF_REQ,  OF_ID,  -1},
> > > > >     {"qcom,clk-freq-out",    &dev->clk_freq_out,    OF_REQ,  OF_U32,  0},
> > > > >     {"qcom,clk-freq-in",    &dev->clk_freq_in,    OF_REQ,  OF_U32,  0},
> > > > >     {"qcom,disable-dma",    &dev->disable_dma,    OF_OPT,  OF_BOOL, 0},
> > > > >     {"qcom,master-id",    &dev->mstr_id,        OF_SGST, OF_U32,  0},
> > > > >     {NULL,            NULL,            0,       0,       0},
> > > > > };
> > > > >
> > > > > Then call populate to read the values into the device’s variables:
> > > > >
> > > > > ret = of_prop_populate(dev, dev->of_node, map);
> > > > 
> > > > Interesting idea. The main concern I have with this is there has been
> > > > on-going discussions about how to generalize property handling across
> > > > DT and ACPI to make drivers more agnostic, so I'm copying a few folks
> > > > involved in that. That may be a bit orthogonal to what this is doing,
> > > > but we may want some coordination here.
> > > 
> > > Agreed.
> > > 
> > > We actually have a patchset adding a unified device property API in 
> > > linux-next (http://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/log/?h=device-properties)
> > > and I'd prefer to see the "compactization" to happen at that level, if possible,
> > > rather that for of_ only.
> > 
> > Agreed, this should definitely use the new generalized API.
> > I have prototyped a similar concept last year, which actually went much
> > further and also abstracted high-level properties such as interrupts,
> > gpios, pwm, dma-engine, etc. I still think we should do something
> > like that, but I've never had the time to follow up and nobody else
> > picked up my work from back then.
> > 
> > Would others like to see that?
> 
> Absolutely. I also tried to do the same thing and didn't get very far.
> And, yes, it should be done at the level of the device properties API.


This is taken from an old email I sent last year on the subject "Re:
[RFC PATCH dtc] C-based DT schema checker integrated into dtc". I haven't
actually followed up at all, and couldn't find the file now, so this
is all I have.

	Arnd

#if 0
/* allocate drvdata */
DEVM_ALLOC,

/* request hardware properties */
DEVM_IRQ,
DEVM_IOMAP,
DEVM_GPIO,
DEVM_DMA_SLAVE,
DEVM_PINCTRL,
DEVM_REGULATOR,
DEVM_CLK,
DEVM_PWM,
DEVM_USBPHY,

/* auxiliary information */
DEVM_PROP_BOOL
DEVM_PROP_U32
DEVM_PROP_STRING
#endif

#error don't bother compiling this file, it's only proof-of-concept

struct device;

struct devm_probe {
        int (*initfunc)(struct device *dev, const struct devm_probe *probe);
        ptrdiff_t offset;
        unsigned int index;
        const char *name;
        void *arg;
        unsigned int flags;
};

/* like offsetof(), but ensures that MEMBER is of type MEMBERTYPE */
#define offsetof_t(TYPE, MEMBER, MEMBERTYPE) \
        ((typeof(MEMBER)*)0 - typeof(MEMBERTYPE*)0 + offsetof((TYPE), (MEMBER)))

/* cast 'ptr' to void* and cause a build warning if it wasn't of 'type' before */
#define typecheck_ptr(ptr, type) \
        (void *)(ptr - (type)NULL + (type)NULL)

/*
 * This is the main entry point for drivers: 
 *
 * Given an zero-terminated array of 'struct devm_probe' entries,
 * this calls all initfunc pointers in the given order. Each initfunc
 * may manipulate a field in the driver_data, as pointed to by
 * the 'offset' member.
 */
int devm_probe(struct device *dev, const struct devm_probe *probe)
{
        int ret;

        for (ret = 0; !ret && probe->initfunc, probe++)
                ret = probe->initfunc(dev, probe);

        return ret;
}
EXPORT_SYMBOL_GPL(devm_probe);

/*
 * this must be the called before any of the others, or not at
 * all, if dev_set_drvdata() has already been called.
 */
static void devm_probe_alloc_release(struct device *dev, void *res)
{
        dev_set_drvdata(dev, NULL);
}
int devm_probe_alloc(struct device *dev, const struct devm_probe *probe)
{
        void *dr;

        if (dev_get_drvdata)
                return -EBUSY;

        dr = alloc_dr(devm_probe_alloc_release, probe->offset, GFP_KERNEL);
        if (unlikely(!dr))
                return -ENOMEM;

        dev_set_drvdata(dev, dr);
        set_node_dbginfo(&dr->node, "devm_probe_alloc", size);
        devres_add(dev, dr->data);
}
EXPORT_SYMBOL_GPL(devm_probe_alloc);


#define DEVM_ALLOC(_struct) \
        { .initfunc = devm_probe_alloc, .offset = sizeof(struct _struct), }

int devm_probe_irq(struct device *dev, const struct devm_probe *probe)
{
        int ret;
        int irq;
        int *irqp;
        int index;
        const char *name;

        /* come up with a reasonable string for the irq name,
           maybe create devm_kasprintf() to allow arbitrary length? */
        name = devm_kmalloc(dev, 32, GFP_KERNEL);
        if (!name)
                return -ENOMEM;
        if (probe->name)
                snprintf(name, 32 - 1, "%s:%s", dev_name(dev), probe->name);
        else
                snprintf(name, 32 - 1, "%s:%n", dev_name(dev), probe->index);

        /* find IRQ number from resource if platform device */
        irq = 0;
        if (dev->bus_type == &platform_bus) {
                struct platform_device *pdev = to_platform_device(dev);

                if (probe->name)
                        irq = platform_get_irq_byname(pdev, probe->name);
                else
                        irq = platform_get_irq(pdev, probe->index);
        }

        /* try getting irq number from device tree if that failed */
        if (!irq && dev->of_node) {
                if (probe->name)
                        index = of_property_match_string(dev->of_node,
                                                         "interrupt-names",
                                                         probe->name);
                else
                        index = probe->index;

                irq = irq_of_parse_and_map(dev->of_node, index);
        }

        /* copy irq number to driver data */
        irqp = dev_get_drvdata(dev) + probe->offset;
        *irqp = irq;
        
        return devm_request_irq(dev, irq, probe->arg, probe->flags, name, probe->dev);
}
EXPORT_SYMBOL_GPL(devm_probe_irq);

#define DEVM_IRQ(_struct, _member, _index, _handler, _flags) {  \
        .initfunc = devm_probe_irq,                             \
        .offset = offsetof_t(struct _struct, _member, int),     \
        .index = _index,                                        \
        .arg = typecheck_ptr((_handler), irq_handler_t),        \
        .flags = _flags,                                        \
}       

#define DEVM_IRQ_NAMED(_struct, _member, _name, _handler, _flags) { \
        .initfunc = devm_probe_irq,                             \
        .offset = offsetof_t(struct _struct, _member, int),     \
        .name = _name,                                          \
        .arg = typecheck_ptr((_handler), irq_handler_t),        \
        .flags = _flags,                                        \
}       


#define DEVM_IOMAP_NOREQUEST 1

int devm_probe_iomap(struct device *dev, const struct devm_probe *probe)
{
        struct resource res, *resp;
        void __iomem *vaddr;
        void * __iomem *vaddrp;
        int ret;

        /* find mem resource from platform device */
        if (dev->bus_type == &platform_bus) {
                struct platform_device *pdev = to_platform_device(dev);

                if (probe->name)
                        resp = platform_get_resource_byname(pdev,
                                        IORESOURCE_MEM, probe->name);
                else
                        resp = platform_get_resource(pdev,
                                        IORESOURCE_MEM, probe->index);
        }

        /* try getting resource from device tree if that failed */
        if (!resp && dev->of_node) {
                if (probe->name)
                        index = of_property_match_string(dev->of_node,
                                                         "reg-names",
                                                         probe->name);
                else
                        index = probe->index;

                ret = of_address_to_resource(dev->of_node, index, &res);
                if (ret)
                        return ret;
                resp = &res;
        }


        if (probe->flags & DEVM_IOMAP_NOREQUEST) {
                vaddr = devm_ioremap(dev, resp->start, resource_size(resp));
                if (!vaddr)
                        return -EINVAL;
        } else {
                vaddr = devm_ioremap_resource(dev, resp);
                if (IS_ERR(vaddr))
                        return PTR_ERR(vaddr);
        }

        vaddrp = dev_get_drvdata(dev) + probe->offset;
        *vaddrp = vaddr;

        return 0;
}
EXPORT_SYMBOL_GPL(devm_probe_iomap);

#define DEVM_IOMAP(_struct, _member, _index, _flags) {                  \
        .initfunc = devm_probe_iomap,                                   \
        .offset = offsetof_t(struct _struct, _member, void __iomem *),  \
        .index = _index,                                                \
        .flags = _flags,                                                \
}       

#define DEVM_IOMAP_NAMED(_struct, _member, _name, _flags) {             \
        .initfunc = devm_probe_iomap,                                   \
        .offset = offsetof_t(struct _struct, _member, void __iomem *),  \
        .name = _name,                                                  \
        .flags = _flags,                                                \
}       

int devm_probe_gpio(struct device *dev, const struct devm_probe *probe)
{
        struct gpio_desc *desc, **descp;

        desc = devm_gpiod_get_index(dev, probe->name, probe->index);
        if (IS_ERR(desc)) {
                /* FIXME: this looks wrong */
                desc = of_get_named_gpiod_flags(dev->of_node, probe->name,
                                                probe->index, NULL);
                if (IS_ERR(desc))
                        return PTR_ERR(desc);
                devm_gpio_request(dev, desc_to_gpio(desc), probe->name);
        }

        descp = dev_get_drvdata(dev) + probe->offset;
        *descp = desc;

        return 0;
}

#define DEVM_GPIO(_struct, _member, _index) {                            \
        .initfunc = devm_probe_iomap,                                    \
        .offset = offsetof_t(struct _struct, _member, struct gpio_desc*),\
        .name = "gpios",                                                 \
        .index = _index,                                                 \
}       

#define DEVM_GPIO_NAMED(_struct, _member, _name) {                       \
        .initfunc = devm_probe_iomap,                                    \
        .offset = offsetof_t(struct _struct, _member, struct gpio_desc*),\
        .name = _name,                                                   \
}       

static void devm_probe_dma_release(struct device *dev, void *chanp)
{
        dma_release_channel(*(struct dma_chan**)chanp);
}

int devm_probe_dma(struct device *dev, const struct devm_probe *probe)
{
        struct dma_chan *chan, **chanp;

        /* there is no devm_dma_request_channel yet, so build our own */
        chanp = devres_alloc(devm_probe_dma_release, sizeof(chanp), GFP_KERNEL);
        if (!chanp)
                return -ENOMEM;

        chan = dma_request_slave_channel(dev, probe->name);
        if (!chan) {
                devres_free(chanp);
                return -EINVAL;
        }

        *chanp = chan;
        devres_add(dev, chanp);

        /* add pointer to the private data */
        chanp = dev_get_drvdata(dev) + probe->offset;
        *chanp = chan;

        return 0;
}

#define DEVM_DMA_SLAVE(_struct, _member, _name)                         \
        .offset = offsetof_t(struct _struct, _member, struct dma_chan*),\
        .name = _name,                                                  \
}

/*
 * simple properties: bool, u32, string
 * no actual need for managed interfaces, just a way to abstract the
 * access to DT or other information source
 */
int devm_probe_prop_bool(struct device *dev, struct devm_probe *probe)
{
        bool *val;

        val = dev_get_drvdata(dev) + probe->offset;
        *val = of_property_read_bool(dev->of_node, probe->name);

        return 0;
}
EXPORT_SYMBOL_GPL(devm_probe_prop_bool);

#define DEVM_PROP_BOOL(_struct, _member, _name)                 \
        .offset = offsetof_t(struct _struct, _member, bool),    \
        .name = _name,                                          \
}

int devm_probe_prop_u32(struct device *dev, struct devm_probe *probe)
{
        u32 *val;
        int ret;

        val = dev_get_drvdata(dev) + probe->offset;
        ret = of_property_read_u32(dev->of_node, probe->name, val);

        return ret;
}
EXPORT_SYMBOL_GPL(devm_probe_prop_bool);

#define DEVM_PROP_U32(_struct, _member, _name)                  \
        .offset = offsetof_t(struct _struct, _member, u32),     \
        .name = _name,                                          \
}

int devm_probe_prop_string(struct device *dev, struct devm_probe *probe)
{
        const char **val;
        int ret;

        val = dev_get_drvdata(dev) + probe->offset;
        ret = of_property_read_string(dev->of_node, probe->name, val);

        return ret;
}
EXPORT_SYMBOL_GPL(devm_probe_prop_bool);

#define DEVM_PROP_STRING(_struct, _member, _name)                       \
        .offset = offsetof_t(struct _struct, _member, const char *),    \
        .name = _name,                                                  \
}

/* example driver */
struct foo_priv {
        spinlock_t lock;
        void __iomem *regs;
        int irq;
        struct gpio_desc *gpio;
        struct dma_chan *rxdma;
        struct dma_chan *txdma;
        bool oldstyle_dma;
};

static irqreturn_t foo_irq_handler(int irq, void *dev);

/*
 * this lists all properties we access from the driver. The list
 * is interpreted by devm_probe() and can be programmatically
 * verified to match the binding.
 */
static const struct devm_probe foo_probe_list[] = {
        DEVM_ALLOC(foo_priv),
        DEVM_IOMAP(foo_priv, regs, 0, 0),
        DEVM_PROP_BOOL(foo_priv, oldstyle_dma, "foo,oldstyle-dma"),
        DEVM_DMA_SLAVE(foo_priv, rxdma, "rx");
        DEVM_DMA_SLAVE(foo_priv, txdma, "tx");
        DEVM_GPIO(foo_priv, gpio, 0);
        DEVM_IRQ_NAMED(foo_priv, irq, foo_irq_handler, "fifo", IRQF_SHARED),
        {},
};

static int foo_probe(struct platform_device *dev)
{
        int ret;

        ret = devm_probe(dev->dev, foo_probe_list);
        if (ret)
                return ret;

        return bar_subsystem_register(&foo_bar_ops, dev);
}
